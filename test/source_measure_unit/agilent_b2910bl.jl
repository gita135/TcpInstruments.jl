using TcpInstruments
using Test
using Unitful

smu = initialize(AgilentB2910BL)
TcpInstruments.instrument_reset(smu)
@info "Successfully connected $(smu.model) at $(smu.address)"

"""
Spec:

    enable_output()
    disable_output()

    set_source()
    get_source()

    set_source_mode()
    get_source_mode()

    set_measurement_mode()
    spot_measurement()

    set_measurement_range()
    set_measurement_duration()

    set_voltage_output()
    set_voltage_limit()
    set_voltage_sweep_parameters()

    set_current_output()
    set_current_limit()
    set_current_sweep_parameters()

    start_measurement()
    get_measurement()

"""


@testset "Output" begin
    enable_output(smu)
    @test query(smu, ":OUTP?") ==  "1"

    disable_output(smu)
    @test query(smu, ":OUTP?") ==  "0"
end

@testset "Voltage" begin
    set_source(smu; source="voltage")
    @test get_source(smu) == "VOLT"

    set_voltage_output(smu, 3.3*u"V")
    @test f_query(smu, "SOUR:VOLT:LEV:IMM:AMPL?") == 3.3
    
    set_voltage_output(smu, "maximum")
    @test f_query(smu, "SOUR:VOLT:LEV:IMM:AMPL?") != 3.3

    @test_throws ErrorException set_voltage_output(smu, "Throw")
    @test_throws ErrorException set_voltage_output(smu, 10)
    @test_throws ErrorException set_voltage_output(smu, 10*u"A")

    set_voltage_limit(smu, 5.0*u"V")
    @test f_query(smu, "SENS:VOLT:PROT?") == 5.0

    set_voltage_limit(smu, "maximum")
    @test f_query(smu, "SENS:VOLT:PROT?") != 5.0

    @test_throws ErrorException set_voltage_limit(smu, "Throw")
    @test_throws ErrorException set_voltage_output(smu, 10)
    @test_throws ErrorException set_voltage_output(smu, 10*u"A")
end

@testset "Current" begin
    set_source(smu; source="current")
    @test get_source(smu) == "CURR"

    set_current_output(smu, 0.33*u"A")
    @test f_query(smu, "SOUR:CURR:LEV:IMM:AMPL?") == 0.33
    
    set_current_output(smu, "maximum")
    @test f_query(smu, "SOUR:CURR:LEV:IMM:AMPL?") != 0.33

    @test_throws ErrorException set_current_output(smu, "Throw")
    @test_throws ErrorException set_current_output(smu, 10)
    @test_throws ErrorException set_current_output(smu, 10*u"V")

    set_current_limit(smu, 1.0*u"A")
    @test f_query(smu, "SENS:CURR:PROT?") == 1.0

    set_current_limit(smu, "maximum")
    @test f_query(smu, "SENS:CURR:PROT?") != 1.0

    @test_throws ErrorException set_current_limit(smu, "Throw")
    @test_throws ErrorException set_current_output(smu, 10)
    @test_throws ErrorException set_current_output(smu, 10*u"V")
end

@testset "Measurement Mode" begin

    set_measurement_mode(smu; voltage=true, current=true, resistance=true)
    @test query(smu, ":SENS:FUNC?") == "\"VOLT\",\"CURR\",\"RES\""

    set_measurement_mode(smu; voltage=true)
    @test query(smu, ":SENS:FUNC?") == "\"VOLT\""

    set_measurement_mode(smu; current=true)
    @test query(smu, ":SENS:FUNC?") == "\"CURR\""

    set_measurement_mode(smu; resistance=true)
    @test query(smu, ":SENS:FUNC?") == "\"VOLT\",\"CURR\",\"RES\""

    set_measurement_mode(smu; voltage=true, current=true)
    @test query(smu, ":SENS:FUNC?") == "\"VOLT\",\"CURR\""

    @test_throws ErrorException set_measurement_mode(smu)
end

@testset "Spot Measurement" begin

    @test spot_measurement(smu, "voltage") isa Unitful.Voltage
    @test spot_measurement(smu, "current") isa Unitful.Current
    @test spot_measurement(smu, "resistance") isa Resistance
    @test_throws ErrorException  spot_measurement(smu, "Throw")
   
    @test spot_measurement(smu) isa Tuple
end

@testset "Set measurement mode and get data " begin
    TcpInstruments.instrument_reset(smu)

    set_measurement_mode(smu; voltage=true)
    data = spot_measurement(smu)
    @test data[1] isa Unitful.Voltage
    @test_throws BoundsError data[2] isa Unitful.Current
    @info data

    set_measurement_mode(smu; current=true)
    data = spot_measurement(smu)
    @test data[1] isa Unitful.Current
    @test_throws BoundsError data[2] isa Unitful.Voltage
    @info data

    set_measurement_mode(smu; voltage=true, current=true, resistance=true)
    data = spot_measurement(smu)
    @test data[1] isa Unitful.Voltage
    @test data[2] isa Unitful.Current
    @test data[3] isa Resistance
    @test_throws BoundsError data[4] isa Number
    @info data
end

@testset "Autorange" begin

    enable_autorange(smu; source="voltage")
    @test query(smu, "SOUR:VOLT:RANG:AUTO?") == "1"
    disable_autorange(smu, source="voltage")
    @test query(smu, "SOUR:VOLT:RANG:AUTO?") == "0"
    
    enable_autorange(smu, source="current")
    @test query(smu, "SOUR:CURR:RANG:AUTO?") == "1"
    disable_autorange(smu, source="current")
    @test query(smu, "SOUR:CURR:RANG:AUTO?") == "0"

    @test_throws ErrorException enable_autorange(smu; source = "resistance")
end

@testset "Fixed Mode" begin
    set_source_mode(smu; source="voltage", mode="fixed")
    @test get_source_mode(smu; source="voltage") == "FIX"

    set_source_mode(smu; source="current", mode="fixed")
    @test get_source_mode(smu; source="current") == "FIX"
end

@testset "Sweep Mode" begin

    set_source_mode(smu; source="voltage", mode="sweep")
    @test get_source_mode(smu; source="voltage") == "SWE"
    
    set_source_mode(smu; source="current", mode="sweep")
    @test get_source_mode(smu; source="current") == "SWE"

    set_voltage_sweep_parameters(smu; start=-1u"V", stop=3u"V", step=0.1u"V")
    @test f_query(smu, "SOUR:VOLT:START?") == -1.0
    @test f_query(smu, "SOUR:VOLT:STOP?") == 3.0
    @test f_query(smu, "SOUR:VOLT:STEP?") == 0.1

    set_voltage_sweep_parameters(smu; start="minimum", stop="maximum", step=1*u"V")
    @test f_query(smu, "SOUR:VOLT:START?") != -1.0
    @test f_query(smu, "SOUR:VOLT:STOP?") != 3.0
    @test f_query(smu, "SOUR:VOLT:STEP?") != 0.1

    set_current_sweep_parameters(smu; start=0u"A", stop=1u"A", step=0.1u"A")
    @test f_query(smu, "SOUR:CURR:START?") == 0.0
    @test f_query(smu, "SOUR:CURR:STOP?") == 1.0
    @test f_query(smu, "SOUR:CURR:STEP?") == 0.1

    set_current_sweep_parameters(smu; start="minimum", stop="maximum", step=0.1*u"A")
    @test f_query(smu, "SOUR:CURR:START?") != 0.0
    @test f_query(smu, "SOUR:CURR:STOP?") != 1.0
    @test f_query(smu, "SOUR:CURR:STEP?") == 0.1
end

@testset "Measurement Range" begin

    set_measurement_range(smu, 1u"V")
    set_measurement_range(smu, measurement="voltage", range="maximum")
    @test f_query(smu, "SENS:VOLT:RANGE?") != 1
    
    set_measurement_range(smu, 1u"A")
    set_measurement_range(smu, measurement="current", range="maximum")
    @test f_query(smu, "SENS:CURR:RANGE?") != 1

    set_measurement_range(smu, 1u"Ω")
    set_measurement_range(smu, measurement="resistance", range="maximum")
    @test f_query(smu, "SENS:RES:RANGE?") != 1

    @test_throws ErrorException set_measurement_range(smu, 1)
    @test_throws ErrorException set_measurement_range(smu, measurement="voltage", range="Throw")

end

@testset "Measurement Duration" begin

    set_measurement_duration(smu; aperture=0.1u"s")
    @test f_query(smu, "SENS:VOLT:APER?") == 0.1

    set_measurement_duration(smu; aperture="default")
    @test f_query(smu, "SENS:VOLT:APER?") != 0.1

    @test_throws ErrorException set_measurement_duration(smu; aperture = 0.5)
end

@testset "Start/Get Measurement" begin

    @testset "Voltage Sweep" begin

        set_source(smu; source="voltage")
        set_source_mode(smu; source="voltage", mode="sweep")
        set_current_limit(smu, 1u"A" )
        set_voltage_sweep_parameters(smu; start=-2u"V", stop=3u"V", step=0.1u"V")

        start_measurement(smu)
        data = get_measurement(smu)
    
        @test !isempty(data.voltage)
        @test !isempty(data.current)
        @test !isempty(data.resistance)
        @test !isempty(data.time)
    end
    
    @testset "Current Sweep" begin

        set_source(smu; source="current")
        set_source_mode(smu; source="current", mode="sweep")
        set_voltage_limit(smu, 10u"V" )
        set_current_sweep_parameters(smu; start=0u"A", stop=500u"mA", step=0.01u"A")

        start_measurement(smu)
        data = get_measurement(smu)

        @test !isempty(data.voltage)
        @test !isempty(data.current)
        @test !isempty(data.resistance)
        @test !isempty(data.time)
    end
end

@testset "Helper Functions" begin

    @test TcpInstruments.verify_channel(smu, 1) == false
    @test_throws ErrorException TcpInstruments.verify_channel(smu, 2)

    @test TcpInstruments.verify_source("voltage") == false
    @test TcpInstruments.verify_source("current") == false
    @test_throws ErrorException TcpInstruments.verify_source("resistance")

    @test TcpInstruments.verify_source_mode("fixed") == false
    @test TcpInstruments.verify_source_mode("list") == false
    @test TcpInstruments.verify_source_mode("sweep") == false
    @test_throws ErrorException TcpInstruments.verify_source_mode("Throw")

    @test TcpInstruments.verify_measurement("voltage") == false
    @test TcpInstruments.verify_measurement("current") == false
    @test TcpInstruments.verify_measurement("resistance") == false
    @test_throws ErrorException TcpInstruments.verify_measurement("Throw")

    @test TcpInstruments.verify_value_specifier("maximum") == false
    @test TcpInstruments.verify_value_specifier("minimum") == false
    @test TcpInstruments.verify_value_specifier("default") == false
    @test_throws ErrorException TcpInstruments.verify_value_specifier("Throw") == true

    @test TcpInstruments.verify_start(5u"V") == nothing
    @test TcpInstruments.verify_start(5u"A") == nothing
    @test TcpInstruments.verify_start("maximum") == false
    
    @test TcpInstruments.verify_stop(5u"V") == nothing
    @test TcpInstruments.verify_stop(5u"A") == nothing
    @test TcpInstruments.verify_stop("maximum") == false
    
    @test TcpInstruments.verify_stop(5u"V") == nothing
    @test TcpInstruments.verify_step(5u"A") == nothing
    @test TcpInstruments.verify_step("maximum") == false

    @test TcpInstruments.verify_start(5u"V") == nothing
    @test TcpInstruments.verify_start(5u"A") == nothing
    @test TcpInstruments.verify_start("maximum") == false
    
    @test TcpInstruments.verify_voltage(5u"V") == nothing
    @test TcpInstruments.verify_voltage("default") == false
    @test_throws ErrorException  TcpInstruments.verify_voltage(5u"A")

    @test TcpInstruments.verify_current(5u"A") == nothing
    @test TcpInstruments.verify_current("default") == false
    @test_throws ErrorException  TcpInstruments.verify_current(5u"V")

    @test TcpInstruments.verify_aperture(1u"s") == nothing
    @test TcpInstruments.verify_aperture("default") == false
    @test_throws ErrorException  TcpInstruments.verify_aperture(1)

    @test TcpInstruments.attach_unit!(1, "voltage") isa Unitful.Voltage
    @test TcpInstruments.attach_unit!(1, "current") isa Unitful.Current
    @test TcpInstruments.attach_unit!(1, "resistance") isa Number
    @test_throws MethodError TcpInstruments.attach_unit!("Throw") == true

    mode = String[]
    TcpInstruments.add_mode!(mode, "voltage")
    @test join(mode) == "\"voltage\""
    
    TcpInstruments.add_mode!(mode, "current")
    @test join(mode) == "\"voltage\",\"current\""

    TcpInstruments.add_mode!(mode, "resistance")
    @test join(mode) == "\"voltage\",\"current\",\"resistance\""
    @test_throws MethodError TcpInstruments.add_mode!("Throw") == true

end

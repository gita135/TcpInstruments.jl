module TcpInstruments

export 
        Instrument,
        Oscilloscope, 
        MultiMeter,
        PowerSupply,
        WaveformGenerator,
        GenericInstrument,

        initialize,
        terminate,
        reset!,
        connect!,
        close!,
        lock!,
        unlock!,
        query,
        write,

        get_data,

        enable_output!,
        disable_output!,
        get_output,
        set_current_limit!,
        get_current_limit,
        set_voltage!,
        get_voltage,
        set_channel!,
        get_channel,

        lpf_on!,
        lpf_off!,
        get_lpf_state,

        set_impedance_one!,
        set_impedance_fifty!,
        get_impedance,


        AgilentDSOX4024A,
        AgilentDSOX4034A,
        Keysight33612A,
        AgilentE36312A,
        BenchXR,


        instrument_reset,
        instrument_clear,
        instrument_get_id,
        instrument_beep_on,
        instrument_beep_off,
        instrument_set_hilevel,
        # Scope specific commends
        get_data


# common instrument containers
include("instr.jl")
include("instrument.jl")
include("common_commands.jl")

# instruments
include("scope/scope.jl")
include("psu/psu.jl")
#include("awg/awg.jl")
#include("dmm/dmm.jl")

end #endmodule

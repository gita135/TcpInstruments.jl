include("INSTR_TYPES.jl")
# METHOD TEMPLATES
# basic method template: "This method has priority over the more general T:<Union{....} template"
#set_wfm(fgen::INSTR{:Agilent33500B},func="sin",ch=1) = write(fgen.obj,"SOURce$ch:FUNC $func")
# more general method template, superseded by basic method template
#set_wfm(fgen::T,func="sin",ch=1) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:FUNC $func")

# Reset
reset_instr(fgen::T) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"*RST")
# Clear
clear_instr(fgen::T) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"*CLS")
# IDN
get_idn(fgen::T) where {T<:Union{F332x1,F335x2}} = query(fgen.obj,"*IDN?")

# Trigger functionality
# Trigger source
set_trig_sour(fgen::T,ch=1,sour="BUS") where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"TRIG$ch:SOUR $sour")
# Trigger delay
set_trig_del(fgen::T,ch=1,del=0) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"TRIG$ch:DEL $del")
# Trigger level
set_trig_lev(fgen::T,ch=1,lev=1) where {T<:F335x2} = write(fgen.obj,"TRIG$ch:LEV$lev")
# Trigger slope
set_trig_slope(fgen::T,ch=1,slp="positive") where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"TRIG$ch:SLOP $slp")
# Waveform
set_wfm(fgen::T,ch=1,func="sin") where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:FUNC $func")
# Amplitude
set_amplit(fgen::T,ch=1,unit="vpp",volt=0.01) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:VOLT:UNIT $unit\n;SOURce$ch:VOLT $volt")
# Offset
set_offs(fgen::T,ch=1,volt=0.01) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:VOLT:OFFset $volt")
# High Level
set_hilev(fgen::T,ch=1,volt=0.01) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:VOLT:HIGH $volt")
# Low Level
set_lolev(fgen::T,ch=1,volt=0.01) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:VOLT:LOW $volt")
# Duty Cycle
set_duty(fgen::T,ch=1,func="square",duty=0.01) where {T<:F335x2} = write(fgen.obj,"SOURce$ch:FUNC:$func:DCYC $duty")
# Duty Cycle for 33250A
set_duty(fgen::INSTR{:Agilent33250A},ch=1,func="square",duty=0.01) = write(fgen.obj,"SOURce$ch:FUNC:square:DCYC $duty")
# Frequency
set_freq(fgen::T,ch=1,fr=1000) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:FREQ $fr")
# Period
set_per(fgen::T,ch=1,func="sin",per=0.001) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:FUNC:$func:PER $per")
# Phase
set_phase(fgen::T,ch=1,unit="deg",phase=90) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"UNIT:ANGL $unit\n;SOURce$ch:PHAS $phase")
# Phase sync
set_phase_sync(fgen::T,ch=1) where {T<:F335x2} = write(fgen.obj,"SOURce$ch:PHAS:SYNC")
# Symmetry
set_sym(fgen::T,ch=1,func="ramp",sym=50) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:FUNC:$func:SYMM $sym")
# Both Edge times
set_both_edg(fgen::T,ch=1,func="pulse",dt=10e-9) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:FUNC:$func:TRAN $dt")
# Lead Edge time
set_lead_edg(fgen::T,ch=1,func="pulse",dt=10e-9) where {T<:F335x2} = write(fgen.obj,"SOURce$ch:FUNC:$func:TRAN:LEAD $dt")
# Trail Edge time
set_trail_edg(fgen::T,ch=1,func="pulse",dt=10e-9) where {T<:F335x2} = write(fgen.obj,"SOURce$ch:FUNC:$func:TRAN:TRA $dt")
# Width
set_width(fgen::T,ch=1,func="pulse",wd=1e-4) where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"SOURce$ch:FUNC:$func:WIDTh $wd")
# Output Load
set_load(fgen::T,ch=1,load="INF") where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"OUTP$ch:LOAD $load")
# Output Polarity
set_pol(fgen::T,ch=1,pol="normal") where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"OUTP$ch:POL $pol")
# Output on/off
set_outp(fgen::T,ch=1,st="off") where {T<:Union{F332x1,F335x2}} = write(fgen.obj,"OUTP$ch $st")
# Burst on
set_burst_stat(fgen::T,ch=1,st="off") where {T<:F335x2} = write(fgen.obj,"SOUR$ch:BURS:STAT $st")
set_burst_stat(fgen::T,ch=1,st="off") where {T<:F332x1} = write(fgen.obj,"BURS:STAT $st")
# Burst mode
set_burst_mode(fgen::T,ch=1,md="triggered") where {T<:F335x2} = write(fgen.obj,"SOUR$ch:BURS:MODE $md")
set_burst_mode(fgen::T,ch=1,md="triggered") where {T<:F332x1} = write(fgen.obj,"BURS:MODE $md")
# Burst polarity
set_burst_pol(fgen::T,ch=1,pol="normal") where {T<:F335x2} = write(fgen.obj,"SOUR$ch:BURS:GATE:POL $pol")
set_burst_pol(fgen::T,ch=1,pol="normal") where {T<:F332x1} = write(fgen.obj,"BURS:GATE:POL $pol")
# Burst ncycles
set_burst_ncyc(fgen::T,ch=1,nc=1) where {T<:F335x2} = write(fgen.obj,"SOUR$ch:BURS:NCYC $nc")
set_burst_ncyc(fgen::T,ch=1,nc=1) where {T<:F332x1} = write(fgen.obj,"BURS:NCYC $nc")
# Burst period
set_burst_per(fgen::T,ch=1,per=0.01) where {T<:F335x2} = write(fgen.obj,"SOUR$ch:BURS:INT:PER $nc")
set_burst_per(fgen::T,ch=1,per=0.01) where {T<:F332x1} = write(fgen.obj,"BURS:INT:PER $per")
# Burst phase
set_burst_phase(fgen::T,ch=1,unit="deg",phase=0) where {T<:F335x2} = write(fgen.obj,"UNIT:ANGL $unit\n;SOUR$ch:BURS:PHAS $phase")
set_burst_phase(fgen::T,ch=1,unit="deg",phase=0) where {T<:F332x1} = write(fgen.obj,"UNIT:ANGL $unit\n;BURS:PHAS $phase")





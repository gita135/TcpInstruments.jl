"""
Supported Instruments:
≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

  - [`AgilentB2910BL`](@ref)
"""
abstract type SourceMeasureUnit <: Instrument end


"""
Supported model
- `AgilentB2910BL`

Supported functions
- [`initialize`](@ref)
- [`terminate`](@ref)

- [`enable_output`](@ref)
- [`disable_output`](@ref)

- [`set_source`](@ref)
- [`get_source`](@ref)

- [`set_source_mode`](@ref)
- [`get_source_mode`](@ref)

- [`set_measurement_mode`](@ref)
- [`spot_measurement`](@ref)

- [`set_measurement_range`](@ref)
- [`set_measurement_duration`](@ref)

- [`set_voltage_output`](@ref)
- [`set_voltage_limit`](@ref)
- [`set_voltage_sweep_parameters`](@ref)

- [`set_current_output`](@ref)
- [`set_current_limit`](@ref)
- [`set_current_sweep_parameters`](@ref)

- [`start_measurement`](@ref)
- [`get_measurement`](@ref)

"""
struct SourceMeasureUnitData
    voltage::Vector{typeof(1.0u"V")}
    current::Vector{typeof(1.0u"A")}
    resistance::Vector{typeof(1.0u"Ω")}
    time::Vector{typeof(1.0u"s")}
end

abstract type AgilentSourceMeasureUnit <: SourceMeasureUnit end
"""
Supported functions
- [`initialize`](@ref)
- [`terminate`](@ref)

- [`enable_output`](@ref)
- [`disable_output`](@ref)

- [`set_source`](@ref)
- [`get_source`](@ref)

- [`set_source_mode`](@ref)
- [`get_source_mode`](@ref)

- [`set_measurement_mode`](@ref)
- [`spot_measurement`](@ref)

- [`set_measurement_range`](@ref)
- [`set_measurement_duration`](@ref)

- [`set_voltage_output`](@ref)
- [`set_voltage_limit`](@ref)
- [`set_voltage_sweep_parameters`](@ref)

- [`set_current_output`](@ref)
- [`set_current_limit`](@ref)
- [`set_current_sweep_parameters`](@ref)

- [`start_measurement`](@ref)
- [`get_measurement`](@ref)

"""
struct AgilentB2910BL <: AgilentSourceMeasureUnit end

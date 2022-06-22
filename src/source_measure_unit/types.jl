"""
- [`AgilentSourceMeasureUnit`](@ref)
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
- [`set_voltage_mode`](@ref)
- [`set_output_voltage`](@ref)
- [`set_voltage_limit`](@ref)
- [`set_current_mode`](@ref)
- [`set_output_current`](@ref)
- [`set_current_limit`](@ref)
- [`set_measurement_mode`](@ref)
- [`enable_autorange`](@ref)
- [`disable_autorange`](@ref)

#=
TODO - Functions to implement:
- [`set_to_sweep_mode`](@ref)
- [`set_sweep_start`](@ref)
- [`set_sweep_stop`](@ref)
- [`set_sweep_step`](@ref)
- [`set_measurement_range`](@ref)
- [`set_measurement_time`](@ref)
- [`get_measurement`](@ref)
- [`start_measurement`](@ref)
=#
"""
abstract type AgilentSourceMeasureUnit <: SourceMeasureUnit end
struct AgilentB2910BL <: AgilentSourceMeasureUnit end

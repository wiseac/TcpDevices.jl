"""
GPIB Enabled Device. Requires an attached Prologix Controller
to work.


# Available functions
- `enable_output()`
- `disable_output()`
- `set_voltage(volts)`
- `get_voltage()`
- `set_voltage_limit(volts)`
- `get_voltage_limit()`
- `set_current_limit(current)`
- `get_current_limit()`
- `set_prologix_chan(chan)`
- `get_prologix_chan(chan)`
"""
struct SRSPS310 <: PowerSupply end


"""
This will enable an output on a device.

Arguments:
  - obj
    - must be a Power Supply Instrument
Supported Instruments:
   - Power supply
"""
enable_output(obj::Instr{SRSPS310}) = write(obj, "HVON")

"""
This will disable an output on a device.

Arguments:
  - obj
    - must be a Power Supply Instrument
Supported Instruments:
   - Power supply
"""
disable_output(obj::Instr{SRSPS310}) = write(obj, "HVOF")

"""
This will disable an output on a device.

Arguments:
  - obj
    - must be a Power Supply Instrument
Supported Instruments:
   - Power supply

# Returns
- true if High Voltage Output is Off
- false if High Voltage Output is On
"""
get_output(obj::Instr{SRSPS310}) = query(obj, "*STB? 7") == "1" ? true : false


"""
set_voltage(obj::Instr{SRSPS310}, volt::Voltage; [delta_volt::Voltage, delta_time::Time])

Sets the output voltage output of a SRSPS310 power supply.
optional parameters:
delta_volt and delta_time can be used to set the ramping speed when setting a new voltage.
- delta_volt sets how big each voltage step should be.  (standard value: Inf *u"V")
- delta_time sets the time between each voltage update. (standard value: 100u"ms")

Voltage limits can be set using set\_voltage\_limit().

Examples:
psu_h = initialize(SRSPS310)
set_voltage(psu_h, 11.1u"V")
set_voltage(psu_h, 1100"mV")
set_voltage(psu_h, 100"V", delta_volt = 5u"V", delta_time=50u"ms")

Returns:
  Nothing
"""
function set_voltage(obj::Instr{SRSPS310}, volt::Voltage; delta_volt::Voltage=Inf*u"V", delta_time::Time=100u"ms")
    if delta_volt == Inf*u"V"
        _set_voltage(obj, v)
    else
        v_start = get_voltage(obj)
        v_end   = volt
        v_steps = v_start:delta_volt:v_end

        for v in v_steps
            _set_voltage(obj, v)
            sleep(raw(delta_time))
            _set_voltage(obj, v)
        end

        if v_steps[end] != voltage
            sleep(raw(delta_time))
            _set_voltage(obj, v)
        end
    end
    return nothing
end

_set_voltage(obj::Instr{SRSPS310}, v::Voltage) = write(obj, "VSET$(raw(v))")

"""
This will return the voltage of a device

Voltage Limit: 1250V

Supported Instruments:
   - Power supply

Returns:
  Voltage
"""
get_voltage(obj::Instr{SRSPS310}) = f_query(obj, "VSET?") * V

"""
    set_voltage_limit(::SRSPS310, voltage_limit)

This will change the voltage limit of a device.

Max Voltage Limit: 1250V

Supported Instruments:
   - Power supply

Returns:
  Nothing
"""
set_voltage_limit(obj::Instr{SRSPS310}, num::Voltage) = write(obj, "VLIM$(raw(num))")

"""
This will return the voltage limit of a device

Voltage Limit: 1250V

Supported Instruments:
   - Power supply

Returns:
  Voltage
"""
get_voltage_limit(obj::Instr{SRSPS310}) = f_query(obj, "VLIM?") * V

"""
This will change the current limit of a device

MIN Value: 0
Max Value: { 2.1e-3 | 0.021 } (21mA)

Supported Instruments:
   - Power supply

Returns:
  Nothing
"""
function set_current_limit(obj::Instr{SRSPS310}, num::Current)
    write(obj, "ILIM$(raw(num))")
end

"""
This will return the current limit of a device.


Supported Instruments:
   - Power supply

Returns:
  Current Limit
"""
get_current_limit(obj::Instr{SRSPS310}) = f_query(obj, "ILIM?") * A

function scan_prologix(obj::Instr{SRSPS310})
    devices = Dict()
    for i in 0:15
        write(obj, "++addr $i")
        try
            devices[i] = query(obj, "*IDN?"; timeout=0.5)
        catch

        end
    end
    devices
end

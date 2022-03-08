```@meta
CurrentModule = TcpInstruments
```

## General functions
```@meta
CurrentModule = TcpInstruments
```

- [`initialize`](@ref)
- [`terminate`](@ref)
- [`info`](@ref)
- [`scan_network`](@ref)
- [`save`](@ref)
- [`load`](@ref)

```@docs
initialize
terminate
info
scan_network
save
load
```


## Impedance Analyzer
```@autodocs
Modules = [TcpInstruments]
Pages = ["src/impedance_analyzer/all.jl"]
```

### Agilent4294A
```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/impedance_analyzer/Agilent4294A.jl"]
```

### Agilent4395A
#### WIP
```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/impedance_analyzer/Agilent4395A.jl"]
```


## Multimeter
```@autodocs
Modules = [TcpInstruments]
Pages = ["src/multimeter/all.jl"]
```

### KeysightDMM34465A
```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/multimeter/KeysightDMM34465A.jl"]
```


## Oscilloscope
```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/oscilloscope/scope_common.jl"]
```

### AgilentDSOX4024A
```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/oscilloscope/AgilentDSOX4024A.jl"]
```

### AgilentDSOX4034A
```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/oscilloscope/AgilentDSOX4034A.jl"]
```


## Power Supply
```@autodocs
Modules = [TcpInstruments]
Pages = ["src/power_supply/all.jl"]
```

### AgilentE36312A
```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/power_supply/AgilentE36312A.jl"]
```

### SRSPS310
This device needs a gpib adapter

As of right now the prologix adapter interface is the only
supported adapter.

Connect your power supply to a prologix adapter then
initialize using the `GPIB_ID` keyword argument.

If you do not know the GPIB Channel ID you can initialize
your device without that flag. Then run `scan_prologix` on
your device. This will tell you what channel is connected
then manually you can use the `set_prologix` function to
set the channel.

```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/power_supply/SRSPS310.jl"]
```

### VersatilePower
```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/power_supply/VersatilePower.jl"]
```


## Waveform Generator
```@autodocs
Modules = [TcpInstruments]
Pages = ["src/signal_generator/all.jl"]
```

### Keysight33612A
```@autodocs
Modules = [TcpInstruments]
Filter = t -> typeof(t) !== DataType
Pages = ["src/signal_generator/Keysight33612A.jl"]
```
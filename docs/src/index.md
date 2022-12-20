# TcpInstruments.jl

TcpInstruments allows you to control a variety of internet-enabled instruments

SCPI is supported on almost all modern pieces of lab equipment and this code has during development been tested on the following devices:
- Oscilloscope Keysight DSOX4034A
- Oscilloscope Keysight DSOX4024A
- Multimeter Keysight DMM34465A
- Signal generator Keysight 33612A
- Power supply Agilent E36312A
- HV power supply SRS PS310 via Prologix GPIB to Ethernet adaptor
- Power supply Versatile Power 100-10 XR
- Impedance analyzer Agilent 4294A
- SourceMeasureUnit Agilent B2910BL

## Installation
TcpInstruments can be installed using the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run

```
pkg> add TcpInstruments
```

To see the different types of devices you can interface with, run:
```
julia> ?
help?> Instrument
```

Autoinitialize - Storage of name-aliases and IP addresses.

You can create a `~/.tcp_instruments.yml` file which stores the IP-address 
and an optional name-alias for all your devices
in one easy-to-find place so they don't have to be hardcoded in scripts.

To create an example config file that can be edited to your needs run:
```
create_config()
```
This will create a yaml file in your home directory: `~/.tcp_instruments.yml`

This yaml file will be loaded everytime you use this package.

You can also create a project-specific config by creating
the config in your project root directory instead of your home
directory. You can do this with:
```
create_config(pwd())
```

Once you have created a config file you can change it with
```
edit_config()
```

Format of `.tcp_instruments.yml` file:
```julia
{name-of-device}:
    address: "{ip-address}"

# GPIB Device connected with a prologix controller
{name-of-device}:
    gpib: {channel-number}
    address: "{ip-address}"
```

Let's create a new `.tcp_instruments.yml` file or ensure the two previous
devices are found in our `.tcp_instruments.yml` file
```yaml
Keysight33612A:
    address: "10.1.30.36"
    alias: "OleBigSG"
SRSPS310:
    gpib: 2
    address: "10.1.30.37:1234"
```

Recompile the new config which is located in the current working directory
```julia
pkg> activate .
julia> using TcpInstruments
```

Each TcpInstruments will first look for a config in the current directory and if none is found it will look in the home directory.

The two devices from above can now be initialized as follows:
```julia
sg = initialize(Keysight33612A)
p = initialize(SRSPS310)
```

Cool Tip: Since we specified an alias for the signal generator we can initialize it this way as well:
```julia
sg = initialize(OleBigSG)
```

(No dashes, spaces or other special characters in alias names, treat them like variables, because they are.)


To send custom commands where no return response is expected use the `write()` function:
```julia
julia> write(instr, "<SCPI command>")
```

If the device is sending a response to the command use `query()` instead:
```julia
julia> response = query(instr, "<SCPI command>")
```

The convenience functions `f_query()` and `i_query()` parse the response string to a `Float64` and `Int64`, respectively.

## General Usage

To connect to an instrument you must know its model and
IP address:

```julia
using TcpInstruments
instrument_handle = initialize(AgilentDSOX4034A, "10.1.30.32")
info(instrument_handle)
data = get_data(instrument_handle)
save(data)
```
When you are done you can close your connection:
```julia
terminate(instrument_handle)
```

If you do not know the ip address of any devices on your network:
```julia
scan_network()
```

By default `scan_network` will check the addresses between
10.1.30.1 to 10.1.30.255 but you may need to scan a different range,
say: 10.1.150.1-255
```julia
scan_network(; ip_network="10.1.150.")
```

## Units

This package uses Unitful.

In order to control certain devices
it is required to run:
```julia
using Unitful
```

Commands such as:
```julia
set_voltage_offset(instr, 0)
```
will not work you must specify the units:
```julia
set_voltage_offset(instr, 0u"V")
```

## Examples
### Continious sine wave with a signal generator (in this case the Keysight 33612A):
```julia
sg = initialize(Keysight33612A, "10.1.30.36")
set_mode_cw(sg)               # Set to continuous waveform mode
set_function(sg, "SIN")
set_frequency(sg, 1u"kHz")
set_amplitude(sg, 0.1u"V")
set_voltage_offset(sg, 100u"mV")
enable_output(sg)             # sine output starts here
```


### Power Supplies

#### VersatilePower
 
```julia
# Initialize automatically puts this power supply in remote mode
pwr = initialize(VersatilePower)

set_voltage(pwr, 20u"V")
set_current_limit(pwr, 4u"A")
enable_output(pwr)

# Closes connection as with other devices but also puts this
# device back into local mode
terminate(pwr)
```

#### AgilentE36312A
 
```julia
pwr = initialize(AgilentE36312A)

set_channel(pwr, 1)
set_current_limit(pwr, 1)
set_voltage(pwr, 2u"V")
enable_output(pwr) # Enables output on channel 1

set_channel(pwr, 2)
set_voltage(pwr, 10u"V")
enable_output(pwr) # Enables output on channel 2

set_channel(pwr, 3)
set_voltage(pwr, 10u"V")

set_voltage(pwr, 0u"V"; chan=1) # Changes voltage of channel 1

get_voltage(pwr) # Get voltage channel 3
get_voltage(pwr; chan=2)
get_voltage(pwr; chan=1)

enable_output(pwr) # Enables output on channel 3
```


#### GPIB Power Supply (SRSPS310) used with Prologix Controller
 
To a initialize a device that is connected with a prologix
controller you must specify what prologix channel the device
is on. At this moment the prologix adapter is the only supported
GPIB to Ethernet adapter.
```julia
p = initialize(SRSPS310, "10.1.30.37:1234"; GPIB_ID=2)
```
If you don't know the channel you can figure it out and configure
it manually:
```julia
julia> using TcpInstruments
julia> p = initialize(SRSPS310, "10.1.30.37:1234")
julia> scan_prologix(p)
2 => "PS310"
julia> set_prologix(p, 2)
julia> get_prologix(p)
2
```
Using SRSPS310 Power Supply:
```julia
p = initialize(SRSPS310, "10.1.30.37:1234"; GPIB_ID=2)
set_voltage_limit(p, 1250u"V")
set_voltage(p, 1250u"V")
set_current_limit(p, 0.021u"A") # equivalent to set_current_limit(p, 21u"mA")
enable_output(p)
```

### Oscilloscopes

#### AgilentDSOX4034A
 

```julia
scope = initialize(AgilentDSOX4034A)

# Turn on Low Pass Filter 25MHz
lpf_on(scope)

# See that low pass filter is on
get_lpf_state(scope)

# Turn Off Low Pass Filter 25MHz
lpf_off(scope)

# See that low pass filter is off
get_lpf_state(scope)


set_impedance_1Mohm(scope)
@info get_impedance(scope)

set_impedance_50ohm(scope)
@info get_impedance(scope)

# Get data from channel 1
data = get_data(scope, 1)

# Get data from channel 1, 2, & 4
# Returns 3 element array of data from each channel
multi_data = get_data(scope, [1,2, 4])


using Plots

plot(data)

# Plots channel 1
plot(multi_data[1])

# Plots channel 2
plot(multi_data[2])

# Plots channel 4
plot(multi_data[3])

# Saves data to a file
save(multi_data)
```

Additionally you can grab data from all open channels
(Let's say only channels 1 & 2 are activated for now)
```julia
scope = initialize(AgilentDSOX4034A)
data = get_data(scope)    
```
Since the only activated channels are now only 1 & 2 this returns an array of waves (equivalent to `get_data(scope, [1,2]))

You can also plot multiple waves at once:
```julia
plot(data)
```

![wave](examples/wave.png)


### Impedance Analyzers
TODO: example with the Agilent4294A.

### Multiple devices
 
Lets say you want to use a signal generator, power supply
and oscilloscope all at once.
```julia
using TcpInstruments
using Plots; plotly()

scope = initialize(AgilentDSOX4034A)
pwr   = initialize(VersatilePower)
sg    = initialize(Keysight33612A)

set_mode_cw(sg)
set_function(sg, "SIN")
set_frequency(sg, 1000u"Hz")
set_amplitude(sg, 0.1u"A")
set_voltage_offset(sg, 0u"V")
enable_output(sg)

set_voltage(pwr, 20u"V")
set_current_limit(pwr, 4u"A")
enable_output(pwr)

data_array = get_data(scope, [1,2])
plot(data_array)
```

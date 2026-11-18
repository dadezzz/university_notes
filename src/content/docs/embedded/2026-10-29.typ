#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Analog-to-digital conversion with comparator arrays and encoders, plus serial interfaces: UART framing, I2C master/slave bus, and SPI full-duplex lines.",
  lang: "en",
  title: "Analog-to-digital conversion and serial interfaces",
))

= Analog-to-digital converter (ADC)

Embedded systems often need to measure physical quantities, which are usually
continuous (analog) signals, but computers can only process data in digital
form.

Example: a pressure sensor emits a voltage level that is proportional to the
pressure it senses.

In an ADC, $n$ comparators with different thresholds each emit a logic 0 or 1
depending on whether $V_"in" > i / n V_"ref"$ for $i = 1, ..., n$; an encoder
then takes all the comparator outputs and emits a binary number proportional to
$V_"in"$.

The component usually has a clock input that determines the rate at which analog
values are sampled. The output value stays stable in the period between
samplings.

= Serial interfaces

Communication between an MCU and external sensors can be done through a parallel
bus interface, which uses as many wires as the required number of bits, or
through serial protocols that transmit bits sequentially over a single wire.

== Universal asynchronous receiver-transmitter (UART)

UART is an asynchronous protocol, so it eliminates the clock line. Devices
assume that both ends use the same baud rate and bit order (LSB or MSB first).

The transmitter must add a start bit to indicate the start of each data frame.
The receiver detects the falling edge of the start bit and uses it to
synchronize its sampling clock for the whole data frame. A stop bit is also put
at the end to detect framing errors.

== Inter-integrated circuit (I2C)

I2C is a protocol for short-distance ($< 1 thick upright(m)$) communication that
aims to simplify the wiring requirements. It allows bi-directional communication
by taking turns.

There are two lines: serial clock line (SCL) and serial data line (SDA). Both of
them are kept at logic 1 when idle by two pull-up resistors.

Another advantage of I2C is the master/slave architecture, which allows
communication between a single master and multiple slaves on a single line.

The I2C peripheral inside the MCU takes care of generating the clock (if
configured as master), serializing data, acknowledgements, etc.

== Serial peripheral interface (SPI)

The SPI protocol is a synchronous protocol for high transfer speeds. It allows
full-duplex simultaneous transmission, but requires 3 lines plus one for each
slave.

- `SCLK`: clock line, shared by all chips;
- `MOSI`: master out / slave in, shared by all chips;
- `MISO`: master in / slave out, shared by all chips;
- `CS`: chip select line, specific to each master-slave pair;

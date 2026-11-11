#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Memory-mapped GPIO registers on the MSP432, multiplexer selection of alternate peripheral functions, pull-up and pull-down resistors, and button debouncing.",
  lang: "en",
  title: "GPIO registers, pull-up resistors and debouncing",
))

= GPIO

GPIO allows the MCU to control a physical pin programmatically, with several
possible functions. A multiplexer allows selecting between GPIO mode and
peripheral mode (connecting the pin to a peripheral device such as UART, SPI or
ADC).

The GPIO port is controlled through memory-mapped registers. There are at least
three registers: data-in, data-out and direction. The direction register
controls whether the pin is an input or an output.

On the MSP432, GPIO ports are designated as `P1` to `P10`, which are also
referred to as digital I/O ports, and `PJ`, which has special functions such as
the external oscillator and JTAG connections. Each port contains up to eight
numbered pins (`PJ` only exposes four).

Common registers on port 1:

#table(
  columns: 5,
  table.header(
    [*Address*], [*Name*], [*Description*], [*Type*], [*Reset value*]
  ),
  `0x4000_4C00`, `P1IN`, [Input register], [R], `0b0000_0000`,
  `0x4000_4C02`, `P1OUT`, [Output register], [R/W], `0b0000_0000`,
  `0x4000_4C04`, `P1DIR`, [Direction register], [R/W], `0b0000_0000`,
  `0x4000_4C06`, `P1REN`, [Resistor enable register], [R/W], `0b0000_0000`,
  `0x4000_4C08`, `P1DS`, [Drive strength register], [R/W], `0b0000_0000`,

  `0x4000_4C0A`,
  `P1SEL0`,
  [Select 0 register (multiplexer control for alternate functions)],
  [R/W],
  `0b0000_0000`,

  `0x4000_4C0C`,
  `P1SEL1`,
  [Select 1 register (multiplexer control for alternate functions)],
  [R/W],
  `0b0000_0000`,
)

#starlight.img(
  "images/gpio-sel0-sel1.png",
  alt: "Multiplexer for choosing alternate functions",
)

== Pull-up and pull-down resistors

Assume we need to read the value of an external button.

If we do not use a pull-up or pull-down resistor and the pin is left floating,
we cannot read the pin's value, since the result will be noise.

- With a pull-up resistor, the input is high when the button is not pressed and
  goes low when it is pressed (the button connects the pin to ground).
- With a pull-down resistor, the input stays low until the button is pressed,
  which connects the pin to the supply voltage.

== Bouncing GPIO input

An external button, when pressed or released, does not produce a clean rising or
falling edge, but generates a series of oscillations.

The microcontroller should not react to the first change, otherwise a single
press could result in multiple interrupts being fired. Instead, it is better to
wait until the fluctuations have settled and then fire the required interrupt.

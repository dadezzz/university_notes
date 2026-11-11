#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Hardware and software timers, compare, capture and PWM modes, watchdog resets, and the MSP432 clock sources that feed the MCLK, SMCLK, ACLK and BCLK signals.",
  lang: "en",
  title: "Hardware timers, watchdog and MSP432 clocks",
))

= Hardware timers

A hardware timer is a digital counter that increments or decrements at a fixed
frequency and resets itself when it reaches 0 or a predefined value. When the
timer resets, it generates an interrupt.

A software timer is similar to the hardware one and is based on it, but it can
be replicated (creating multiple instances, even with different frequencies).
The downside is lower precision than the hardware equivalent.

A standard timer is composed of:

- *Prescaler*: takes the clock source as input, divides its frequency by a
  predefined value, and outputs it to the other components;
- *Timer registers*: they are incremented or decremented after each tick of the
  prescaled clock;

Standard operation modes are:

- *Compare mode*: a register is loaded with a value, which is periodically
  compared with the value in the timer register; if the values are equal, an
  interrupt is generated;
- *Capture mode*: the current value of the timer register is loaded into a
  capture register when certain events occur;
- *PWM mode*: the timer is used by the PWM peripheral as the fundamental time
  unit for the duty cycle;

== Watchdog

A watchdog performs a controlled system restart after a software problem occurs.

It works by counting down from a certain interval, and the software is
responsible for periodically resetting the interval. If the software blocks on a
function and is not able to refresh the counter, the countdown reaches zero and
triggers the restart mechanism.

== Clock on MSP432

Microcontrollers typically have two types of clock source:

- an on-chip oscillator: always present, but less precise;
- an external crystal: more precise;

On the MSP432 we have:

- `LFXTCLK`: low-frequency external oscillator, used for frequencies up to
  $32 thick upright(k "Hz")$;
- `HFXTCLK`: high-frequency external oscillator, used for frequencies in the
  $1 thick upright(M "Hz")$ to $48 thick upright(M "Hz")$ range;
- `DCOCLK`: internal, digitally controlled oscillator with programmable
  frequencies;
- `VLOCLK`: internal, low-power and low-frequency ($9.4 thick upright(k "Hz")$)
  oscillator;
- `REFOCLK`: internal, low-power and low-frequency (programmable) oscillator;
- `MODCLK`: internal, low-power oscillator (typically
  $25 thick upright(M "Hz")$);
- `SYSOSC`: internal oscillator (typically $5 thick upright(M "Hz")$);

All these clocks produce five primary system clock signals:

#table(
  columns: 4,
  table.header(
    [*Clock*], [*Default source*], [*Default frequency*], [*Description*]
  ),
  `MCLK`, `DCO`, $3 thick upright(M "Hz")$, [Master clock for the CPU],
  `HSMCLK`, `DCO`, $3 thick upright(M "Hz")$, [Subsystem master clock],
  `SMCLK`, `DCO`, $3 thick upright(M "Hz")$, [Low-speed subsystem master clock],

  `ACLK`,
  [`LFXT` or `REFO` if no crystal is present],
  $32.768 thick upright(k "Hz")$,
  [Auxiliary clock],

  `BCLK`,
  [`LFXT` or `REFO` if no crystal is present],
  $32.768 thick upright(k "Hz")$,
  [Low-speed backup domain clock for LPM peripherals],
)

#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Embedded systems and their real-time constraints, comparing microcontrollers, microprocessors and FPGAs, with concurrent peripherals and interrupts.",
  lang: "en",
  prev: false,
  title: "Embedded systems, MCUs, microprocessors and FPGAs",
))

= Embedded systems

Embedded systems are a class of computing systems in which hardware and software
are tightly coupled, usually designed for dedicated functionality.

Usually these systems are designed to be part of a larger system, called the
embedding system.

Many of these systems have constraints, such as having to respond to an input
within a fixed amount of time (real time).

= Microcontroller vs. microprocessor

A microcontroller (MCU) is a unit that integrates a typically single-core
processor, memory blocks, digital and analog I/Os and other basic peripherals.

A microprocessor is specialized for computing and offloads other functions to
peripherals such as external RAM, SSD storage or USB devices. It is usually more
powerful than a microcontroller.

Field-Programmable Gate Arrays (FPGAs) are an alternative to microcontrollers.
They consist of an array of logic cells that can be programmed to become
compute, RAM or I/O blocks using a hardware description language (HDL).

== Microcontrollers in embedded systems

MCUs fit naturally in the embedded computing domain: they require low
development and manufacturing costs, they offer enough performance to execute
most control tasks, and they have low power consumption and effective sleep
modes.

#image(
  "images/hardware-comparison.png",
  alt: "Comparison between hardware types",
)

== Concurrency

Peripherals can execute concurrently with the CPU. They signal the completion of
their work through the interrupt controller and transmit data through one or
more system buses.

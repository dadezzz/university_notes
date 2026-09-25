#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Hardware/software co-design, IoT networking, the ARM Cortex families, and a comparison of the Von Neumann and Harvard memory architectures' trade-offs.",
  lang: "en",
  title: "Co-design, IoT, ARM and memory architectures",
))

= Hardware and software co-design

Commonly both the hardware and software for an embedded system are developed in
parallel.

If performance is needed we can get hardware with better specifications.
Otherwise if there are things that aren't performance critical, they could be
pushed to the software layer to maintain the ability to change/upgrade them
later.

= The Internet of Things (IoT)

Embedded devices exchange data and coordinate with software services across the
world.

Connecting devices together allows us to:

- collect measurements beyond the reach of wired infrastructure;
- manage devices and update behaviour remotely;
- coordinate devices that share a physical process;
- combine local sensing with remote storage and analysis;

It also exposes new security, privacy and reliability risks.

== Networking

Networking is a critical component of an IoT system. Wireless systems allow a
much wider range of sensor applications.

= ARM

In this course we will learn about the ARM architecture, specifically we will
use ARM Cortex M4 processor cores with various microcontrollers.

ARM is a family of RISC-based processor architectures well known for its power
efficiency. ARM licenses the intellectual property of the architecture to other
manufacturers, who physically produce the processors.

- Cortex A: high performance processors capable of supporting full operating
  systems;
- Cortex R: high performance for real time applications;
- Cortex M: cost sensitive and power efficient;

#starlight.img("images/arm-timeline.png", alt: "Timeline of ARM architecture")

= Von Neumann vs Harvard architectures

In the Von Neumann architecture memory holds both data and instructions. The CPU
fetches the instruction from memory, decodes and then executes it.

#starlight.img(
  "images/arch-von-neumann.png",
  alt: "Von Neumann architecture diagram",
)

The Harvard architecture has separate memories for data and programs. The
program counter points only to program memory, so self-modifying code cannot be
used. The advantage is doubled memory bandwidth, since instruction and data
accesses can use separate memory buses simultaneously.

#starlight.img("images/arch-harvard.png", alt: "Harvard architecture diagram")

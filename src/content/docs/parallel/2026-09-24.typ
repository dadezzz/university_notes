#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Covers the Von Neumann architecture and datapath, Flynn's taxonomy (SISD, SIMD, MISD, MIMD), implicit parallelism, instruction-level parallelism and pipelining.",
  lang: "en",
  title: "Von Neumann, Flynn's taxonomy, ILP and pipelining",
))

= Von Neumann architecture

Most modern computers are based on the Von Neumann architecture, named after
John von Neumann.

Both program instructions and data are kept in the same memory and are processed
by a CPU according to a sequential instruction stream.

The CPU is characterized by the FDE cycle and the data path.

A machine is composed of 4 main components:

- RAM: used to store instructions and data.
- Control Unit: coordinates instruction fetch, decode and execution and controls
  the movement of operands between registers, memory and execution units.
- Arithmetic Logic Unit: performs basic arithmetic and logic operations.
- Input/Output: interfaces between the machine and the external environment.

== Architectural state

At any point during the execution, the observable state of a sequential machine
is represented by the Program Counter, registers and memory.

Executing an instruction transforms state $S_i$ into state $S_(i + 1)$.

The program defines a sequential order of state transformations, but the
hardware doesn't have to execute each one sequentially.

== Data path

The datapath is the collection of hardware components that store, move and
operate on data, including registers, ALUs, FPUs, load/store units and
interconnections.

#starlight.img("images/datapath-schema.png", alt: "Example datapath schema")

= Flynn's Taxonomy of Computers

There are 4 modes in which a machine can execute operations on data:

- *SISD*: a single instruction operates on a single data element;
- *SIMD*: a single instruction operates on multiple data (array/vector
  processors);
- *MISD*: not commonly used;
- *MIMD*: multiple instructions on multiple data at the same time
  (multiprocessors);

== SISD

In a simple serial architecture, a single logical instruction stream controls
execution and a single data stream is being used as input during any one clock
cycle. The execution happens in-order.

/ Latency: the number of clock cycles an instruction takes to have its data
  available for use by another instruction (lower is better).
/ Throughput: the number of instructions, operations or tasks completed per unit
  of time (higher is better).

A design may aim to minimise latency, maximise throughput or balance both. The
performance of the Von Neumann architecture is influenced by many factors:

- FDE design and ISA (latency);
- ALU technology and PE organization (math bandwidth);
- memory subsystem (latency and memory bandwidth);
- applications (ratio between math operations and read/write operations);

== FDE design

The processor runs at a constant rate (clock frequency), but different
instructions may require a different number of clock cycles to complete.

The average value is reflected in the Cycles per Instruction (CPI) metric.

For numerical workloads, FLOP/s is a measure of how much application-relevant
floating point work a system is able to do per unit of time.

= Implicit parallelism

Implicit parallelism is a form of parallel execution extracted automatically by
the compiler or the hardware, without the programmer explicitly creating
parallel tasks or threads.

At the hardware level, current processors distribute transistors in multiple
functional units and can execute multiple operations in the same cycle. This
enables characteristic mechanisms, notably pipelining and vector operations.

== Instruction-level parallelism (ILP)

It's the ability to execute multiple independent instructions from a single
stream concurrently.

An execution unit (or functional unit) is responsible for performing the
operations as instructed by the program.

A superscalar processor is a CPU that implements ILP within a single processor.
This means that the hardware has the ability to identify independent
instructions and dispatch them in parallel.

== Pipeline

Pipelining is a mechanism used to increase the throughput of instructions and
thus maximise the computational power of the CPU.

#starlight.img("images/pipeline-table.png", alt: "Pipeline utilization graph")

A very common approach is to pipeline the fetch, decode and execution phases, so
that the processor doesn't have to wait for a full memory load on each
instruction. Prefetched instructions are stored in a set of registers called the
*prefetch buffer*.

#starlight.img("images/pipeline-instructions.png", alt: "Pipelined FDE")

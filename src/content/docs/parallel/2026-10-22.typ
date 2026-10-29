#import "../_templates/starlight.typ" as starlight;

#show: starlight.setup

#metadata((
  description: "Roofline model, process and thread distinctions, parallel execution and memory models, plus consistency models such as linearizability and eventual consistency.",
  lang: "en",
  title: "Roofline model, processes and programming models",
))

= Roofline model

The roofline model distinguishes two machine resources that can limit the speed
of the program:

- memory bandwidth;
- peak FLOP/s;

#starlight.img("images/roofline.png", alt: "Roofline model graph")

To place an application on the roofline, we can calculate its coordinates:

- $x = "arithmetic intensity" = "operations" / "bytes transferred"$
- $y = "performance" = "operations" / "total time"$

If an application is memory-bound, we can try to optimize the access pattern to
make it faster. If it is compute-bound, we cannot do much without changing the
architecture of the machine.

= Processes vs threads

A process is a program in execution, managed by the operating system. It has its
own address space and typically consists of a set of instructions executed by a
processor.

A parallel program may consist of multiple processes running on multiple CPUs or
multiple nodes. Creating a process requires a system call, and each process is
isolated from the others: by default, processes do not share their address
space.

IPC mechanisms include pipes, message passing and remote procedure calls (RPC).

A thread is an execution unit within a process that may run concurrently with
other threads on different cores of the processor. Threads share the process's
data and instruction memory, but each thread has its own stack, registers and
program counter. Communication happens through shared memory and
synchronization.

Context switching is the process of switching computation from one
thread/process to another. For processes it takes more time than for threads.

= Parallel programming models

A programming model is a set of abstractions needed to generalize a computer
architecture. It defines fundamental logic units, their organization and
mechanisms for cooperation and synchronization.

== Execution models

Data parallelism assigns data to threads and typically uses shared memory to
cooperate. The fundamental units are defined by how data is mapped to threads
and by the resulting access patterns. Scheduling is fundamental to achieve load
balancing.

Task parallelism assigns a task to a process and typically uses messages to
cooperate. The computation of the program can be expressed as a directed acyclic
graph where each node is a task and directed edges represent dependencies
between tasks.

== Memory model

A memory model describes the interactions of fundamental computation units
through memory and the way they share data, including memory ordering, memory
barriers, consistency and synchronization.

== Cooperation and synchronization

- Cooperation is the ability to solve a specific task concurrently.
- Synchronization mechanisms allow concurrent systems to ensure correct program
  execution.

A programming model can express both at different granularities by providing
different kinds of primitives.

== Consistency model

A consistency model describes the behavior of read and write operations in a
shared or distributed memory system.

There are many approaches:

- Sequential consistency: there exists a total sequential order of all reads and
  writes, and the operations issued by each fundamental execution unit appear in
  the order in which that unit issued them.
- Eventual consistency: if no new writes are made to a data item, all replicas
  eventually converge to the same value. Reads may temporarily return stale
  values, so this model is common in distributed systems that prioritize
  availability and scalability over immediate consistency.
- Linearizability (or atomic consistency): there exists a total order of all
  operations, consistent with their real-time order, such that each operation
  appears to take effect instantaneously at some point between its invocation
  and its response.
- Weak consistency: ordinary reads and writes are not guaranteed to be ordered;
  synchronization operations, such as fences or barriers, are required to
  establish ordering and make writes visible to other execution units.

These models differ in the guarantees they provide and in the performance cost
of enforcing them.

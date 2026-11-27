#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Distributed-memory architectures, network fabrics and topologies (dragonfly, fat-tree, hypercube, torus), performance metrics, the SPMD model and MPI basics.",
  lang: "en",
  title: "Distributed memory: network topologies and MPI",
))

= Distributed memory

Large scientific applications can require hundreds of GB to TB of memory, which
cannot fit in a single machine.

Parallel systems can be categorized into shared-memory architectures, where
processors can access a common memory space, and distributed-memory
architectures, where nodes have local memory and exchange data through a
network.

In a supercomputer, each node has local memory and executes processes
independently. Each node may contain multiple CPUs that share the node's memory.
The network fabric (hardware and software stack that links the nodes) and the
topology used for data transfer strongly affect performance.

== Network

The most common network fabrics are Ethernet-based (usually using RoCE) or
InfiniBand-based.

Network interface controllers (NICs) are the components inside a node that
connect the CPU or its accelerators to the high-speed network. They manage data
movement via packet creation, DMA transfers and other mechanisms.

The topology describes the connectivity of hosts, routers and switches. Common
performance metrics are:

- *Latency* (peer-to-peer): elapsed time to transfer a message of a specified
  size between endpoints. It is usually estimated as half of the RTT. It
  includes send overhead (software and NIC processing and serialization),
  propagation time through cables, switch traversal time (blocking, queues,
  etc.) and receive overhead.
- *Bandwidth* (peer-to-peer): maximum rate at which data can be transmitted
  through a communication channel, expressed as an amount of data per unit of
  time.
- *Diameter* (network-wide): maximum shortest-path distance over all vertex
  pairs in the chosen graph.
- *Bisection bandwidth* (network-wide): minimum link capacity across a cut
  dividing compute endpoints into balanced halves.

Examples of topologies:

#table(
  columns: 5,
  table.header(
    [*Topology*],
    [*Diameter*],
    [*Bisection BW*],
    [*Main trade-off*],
    [*Used in*],
  ),

  [*Dragonfly*],
  [3 (for classic)],
  [Design dependent],
  [Global-link capacity],
  [Frontier, Aurora, Perlmutter],

  [*Fat-tree* / *Clos*],
  [Depth dependent],
  [Full if provisioned],
  [Switch/link cost],
  [Many InfiniBand clusters],

  [*Slim Fly*], [2], [Design dependent], [Router radix], [Research topology],

  [*Hypercube*],
  $log_2(N)$,
  $N B / 2$,
  [Degree grows as $log_2(N)$],
  [Classical HPC],

  [*Torus 3D/5D*],
  $sum_i floor(k_i / 2)$,
  [Size dependent],
  [Locality vs. distance],
  [Blue Gene/Q],

  [*Tofu (6D)*],
  [Size dependent],
  [Size dependent],
  [Mesh/torus locality],
  [Fugaku],

  [*Jellyfish*],
  [Size dependent],
  [Graph dependent],
  [Routing complexity],
  [Research topology],
)

== Programming model

Single program, multiple data (SPMD) is the most widely used programming model
in distributed-memory systems. Every process runs the same program on different
parts of the dataset.

Each process may assume a different role (e.g. computing node, coordinator node,
etc.).

=== MPI

https://www.mpi-forum.org/docs/

Message Passing Interface (MPI) is a standardized communication interface for
parallel processes. It supports both distributed- and shared-memory systems.

```c
#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
  // Initialize the MPI environment.
  // MPI_COMM_WORLD is the predefined communicator that contains every process;
  // a communicator combines an ordered process group with a communication
  // context.
  MPI_Init(&argc, &argv);

  // Each process obtains a rank from 0 to size - 1.
  int my_rank, comm_size;
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
  MPI_Comm_size(MPI_COMM_WORLD, &comm_size);

  MPI_Finalize();
  return 0;
}

// Compile with `mpicc` and run with `mpiexec -n <nproc> ./program`.
```

`mpicc` is the C compiler wrapper provided by the MPI implementation. It wraps
the system compiler (such as GCC, Clang, etc.) and adds the correct include
directories, libraries and compilation flags.

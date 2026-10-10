#import "../_templates/starlight.typ" as starlight;

#show: starlight.setup

#metadata((
  description: "MIMD machines with shared or distributed memory, UMA and NUMA layouts, latency and bandwidth, cache miss categories, AMAT, and cache transfer granularity.",
  lang: "en",
  title: "MIMD memory models and cache performance metrics",
))

= MIMD machines

MIMD machines have independent control units that control independent data
paths, so each processing element can follow its own instruction stream.

A MIMD machine can use two memory models:

- *Shared memory*: uses a common address space, and communication happens
  through shared data with synchronization primitives protecting against
  concurrent operations. The typical programming model is threads.
- *Distributed memory*: uses private/local memories for each PE, communication
  happens through message passing.

Another distinction can be made depending on the memory layout:

- In *UMA* systems, the memory access cost is approximately independent of which
  core accesses a location.
- In *NUMA* systems, there's one address space but accessing local and remote
  memory may have different costs.

#starlight.caution([
  Shared memory in NUMA systems is tricky, since various caching layers are used
  to improve performance, but synchronization primitives must account for this
  to prevent stale reads and false sharing.
])

== Distributed memory MIMD

In MIMD systems with distributed memory, non-local data must be communicated
across nodes. Memory bandwidth and latency are limited by the characteristics of
the network between nodes.

= Memory performance

Memory performance is measured according to two factors:

/ Latency: Time from issuing a memory request until the requested data becomes
  available.
/ Bandwidth: Amount of data transferred per unit of time. Calculated as
  $B_"peak" = "transfer rate" times "bus width" / 8$.

All modern systems use a memory hierarchy that layers different caching
mechanisms, with varying tradeoffs between speed and capacity. Caches exploit
locality and reduce average access time.

The memory controller schedules requests and drives DRAM timing and protocols.

== Memory technologies

Different DRAM (dynamic random-access memory) technologies offer a tradeoff
between cost and bandwidth:

/ DDR (Double Data Rate): Data is transferred twice per clock cycle.
/ HBM (High Bandwidth Memory): Utilizes 3D-stacked DRAM cells.

SRAM uses six transistors instead of one transistor and one capacitor, lowering
latency but requiring more die space. For this reason it's used only in small
caches like CPU L1 and L2.

== Average memory access time

$
  "AMAT" = T_"hit" + "MR" times P_"miss"
$

where $T_"hit"$ is the time spent looking up the cache, $"MR"$ is the rate of
cache misses and $P_"miss"$ is the additional time lost per cache miss.

Cache misses are classified in three categories:

- *Compulsory*: the cache is empty or the block is accessed for the first time.
- *Capacity*: the working set does not fit in cache. Blocks are evicted and
  needed again later.
- *Conflict*: different memory blocks compete for the same cache set or
  location.

== Cache transfer granularity

On cache misses, the next caching layer is read and data is loaded. Typically,
the data loaded is not only the required one, but also subsequent data elements.

For example, loading an element of an array of `char` might also load the next
64 elements into the cache. This is done to improve the hit rate, since typical
data access patterns involve `for` loops that would otherwise trigger a miss on
each iteration.



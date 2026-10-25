#import "../_templates/starlight.typ" as starlight;

#show: starlight.setup

#metadata((
  description: "Cache coherence protocols (snooping, MESI), false sharing on cache lines, arithmetic intensity versus machine balance and parallel memory access patterns.",
  lang: "en",
  title: "Cache coherence, false sharing and memory access",
))

= Cache coherence in multicore systems

Caching layers can be private to a thread or shared among threads.

A problem that typically arises is how to reflect writes to shared data in the
private caches of other threads.

Hardware coherence protocols track the ownership and state of blocks, and they
propagate or invalidate updates. Snooping and MESI are two commonly used
approaches.

== False sharing

Coherence mechanisms operate at the granularity of a cache line, not of a single
scalar variable.

If one thread updates variable $x$ and another thread updates variable $y$, and
the two variables happen to share the same cache line, the updates are not
independent from the hardware's point of view: each write must acquire exclusive
ownership of the whole line, so the line keeps bouncing between the caches and
the updates are serialized. This is called false sharing, and it can severely
limit the speedup even though the variables themselves are unrelated.

== Arithmetic intensity and machine balance

Let us define some terms:

- $"Arithmetic intensity" = "arithmetic operations" / "bytes transferred"$
- $B_"peak" = "transfer rate" times "interface width" / 8 times "channels"$
- $"Machine balance" = P_"peak" / B_"peak"$

If $"Arithmetic intensity" < "machine balance"$, the memory system cannot feed
the arithmetic units at peak rate. Otherwise, if
$"Arithmetic intensity" > "machine balance"$, the arithmetic throughput may
become the limiting resource.

Effective bandwidth is what the application actually sustains:
$B_"eff" = (B_"read" + B_"write") / t$, where $t$ is the total time taken for
the operations to complete. It is lower than peak for a number of reasons: lack
of caching/locality, concurrency (memory requests are not independent),
contention (shared resources), access patterns and transaction efficiency (the
ratio of bytes fetched to bytes actually used).

= Memory access patterns

Different access patterns can be generated from the following formula:
sequential, strided (one access every $n$ elements, with $n = 1$ reducing to
sequential) or even random.

$
  "address"(i) = "base" + "index"(i) times "sizeof"(T)
$

As the stride grows, fewer elements from each cache line may be useful. A
particular case is matrix element access. For row-major layouts, row access
results in sequential addressing, while column access results in strided
addressing. This can impact the performance of matrix multiplication.

Random access is common in sparse matrices, graphs and hash-based data
structures.

== Concurrent access

Parallel access patterns have two dimensions:

- Within one thread over time, it determines the per-thread stride, cache reuse
  and prefetchability.
- Across threads at the same time, it influences coalescing, shared-cache
  traffic and contention.

Some common access patterns are (where $P$ is the number of threads, $N$ the
number of elements and $k$ the per-thread offset):

- *Block distribution*: each thread gets a contiguous chunk, good for private
  cache locality:

  $
    "index"(t, k) = t times N / P + k
  $

- *Cyclic distribution*: each thread has stride $P$ through the array, which is
  better for shared cache locality but less predictable for the prefetcher:

  $
    "index"(t, k) = k times P + t
  $

For SIMD applications, block access is usually better, since the processor
benefits from needing fewer transactions to load data into registers. For
applications that need to update variables often, sparse access allows threads
to avoid contention and false sharing on cache lines.

#import "../_templates/starlight.typ" as starlight;

#show: starlight.setup

#metadata((
  description: "OpenMP directives, parallel regions, data sharing clauses, memory models, static, dynamic and guided loop scheduling, and the reduction clause for sums.",
  lang: "en",
  title: "OpenMP directives, memory models and scheduling",
))

= OpenMP

https://www.openmp.org/spec-html/6.0/openmp.html

OpenMP is an API for shared-memory parallel programming that allows decomposing
a sequential program into components that can be executed in parallel. It
enables the incremental conversion of sequential programs with the assistance of
the compiler, relying on directives: special annotations on the code that modify
the compiler's behavior.

OpenMP supports vectorization, data parallelism and task parallelism.

```c
#include <stdio.h>
#include <omp.h>

int main() {
  const int N = 1000;
  double A[N], B[N], C[N];

  for (int i = 0; i < N; i++) {
    A[i] = i;
    B[i] = 2 * i;
  }

  // Parallel element-wise addition.
  #pragma omp parallel for
  for (int i = 0; i < N; i++) {
    C[i] = A[i] + B[i];
  }

  return 0;
}
```

== Platform model

A process can run several threads on the CPU cores. Caches and NUMA placement
affect latency and bandwidth.

The OpenMP runtime maps software threads to hardware resources, allowing the
customization of placement and binding policies.

When the main thread encounters a parallel region, the runtime forms a team,
typically using OS threads from a reusable pool. Then it applies any configured
affinity constraints and lets the OS schedule the workers on the set of allowed
CPUs.

== API

```
#pragma omp <directive> [clause ...]
```

OpenMP directives are used to describe parallel execution. With `parallel`, each
thread executes the enclosed region once, in unspecified order. The
implementation may reuse worker threads across parallel regions.

If the number of threads is not specified by the user (e.g., with the
`num_threads(n)` clause), the runtime determines it from environment variables
(`OMP_NUM_THREADS`) or automatically, based on the number of available cores.

To compile an OpenMP program, the `-fopenmp` flag must be passed to the
GCC/Clang command line.

Other clauses include:

- `private`, `shared`, `firstprivate`: determine how data is shared among
  threads;
- `schedule(static)`, `schedule(dynamic)`: determine the distribution of work;
- `reduction`: specifies the operator used to combine partial results;

== Memory models

Variables can have different sharing attributes among threads:

- Shared memory (`shared(x)` clause): all threads can access the same memory
  location. The variable `x` doesn't need to be global, but its lifetime must
  outlive that of the parallel region. This is the default if nothing is
  specified.
- Private view (`private(x)` clause): each thread gets a copy of the variable in
  independent memory. The `private` clause does not copy the original value of
  the variable and requires each thread to initialize it.

  With `firstprivate(x)`, the initial value is copied to each instance of the
  variable. With `lastprivate(x)`, the original `x` outside the loop is assigned
  the value from the last iteration.

OpenMP does not synchronize accesses automatically; the programmer must use
explicit clauses (e.g., `barrier`, `critical`, `atomic`) to protect writes from
different threads.

== Schedule models

In OpenMP, scheduling is about mapping iterations to threads, not about creating
threads.

- `schedule(static)`: the assignment of iterations to threads is decided before
  loop execution, in roughly equal-sized contiguous blocks, unless manually
  configured.
- `schedule(dynamic)`: chunks are assigned to threads at runtime, when a thread
  finishes its previous chunk, allowing better load balancing when iterations
  have irregular cost. It involves higher scheduling overhead than `static`.
- `schedule(guided)`: instead of requesting a single chunk like in `dynamic`,
  threads request chunks whose size decreases as fewer iterations remain,
  reducing the scheduling overhead.

== `reduction` clause

A reduction lets each thread accumulate a private partial value; OpenMP then
combines the partial values at the end using the specified operator.

```c
#pragma omp parallel for reduction(+:sum)
for (int i = 0; i < N; i++)
  sum += a[i];
```

This avoids a race on the shared variable and avoids serializing every update
with a critical section.



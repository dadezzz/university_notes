#import "../_templates/starlight.typ" as starlight;

#show: starlight.setup

#metadata((
  description: "Nested parallel regions, places and thread binding, sections, single and masked worksharing, tasks with taskwait and taskgroup, plus barriers and atomics.",
  lang: "en",
  title: "Nested parallelism, places, tasks and barriers",
))

= Nested directives

```c
#pragma omp parallel
{
  #pragma omp for
  for (int i = 0; i < N; i++)
    a[i] = initialize(i);

  #pragma omp for
  for (int i = 0; i < N; i++)
    b[i] = transform(a[i]);
}
```

`parallel` creates a team of threads and one implicit task per thread. `for`
distributes iterations among that existing team. The first loop's implicit
barrier completes initialization.

```c
#pragma omp parallel num_threads(2)
{
  #pragma omp parallel num_threads(3)
  {
    work();
  }
}
```

Nested parallelism is disabled by default; once it is enabled (e.g. with
`OMP_MAX_ACTIVE_LEVELS`), the program can execute up to 6 threads in parallel.

= Hardware topology and places

OpenMP uses *places* to define parts of the machine that are close to each
other. The topology can be controlled with the `OMP_PLACES` environment
variable. There are three pre-defined place names:

- `threads`: each place corresponds to a single hardware thread on the target
  machine;
- `cores`: each place corresponds to a single core (with one or more hardware
  threads);
- `sockets`: each place corresponds to a single socket (consisting of one or
  more cores);

With the `OMP_PROC_BIND` environment variable or the corresponding clause we can
influence where threads are scheduled with respect to places. This is especially
useful on NUMA systems, where memory blocks are allocated depending on the place
that makes the system call. Matching the ownership of initialization and
computation can improve locality.

- `proc_bind(primary)`: all teams use the primary thread's place;
- `proc_bind(close)`: threads occupy nearby places in list order;
- `proc_bind(spread)`: threads spread across place subpartitions;
- `proc_bind(false)`: thread affinity is disabled;

= Other worksharing directives

#table(
  columns: 3,
  table.header([*Directive/clause*], [*Unit of work*], [*Default end barrier*]),
  `sections`, [Independent code blocks], [Yes],
  `single`, [One block, executed by only one thread in the team], [Yes],
  `for collapse(2)`, [Iterations from two nested loops], [Yes],
  `nowait`, [Removes an end barrier], [No],
)

```c
#pragma omp parallel shared(a, b)
{
  #pragma omp sections
  {
    #pragma omp section
    { preprocess(a); }
    #pragma omp section
    { preprocess(b); }
  }
  use_ready_inputs(a, b);
}
```

A thread may execute more than one section. `preprocess(a)` and `preprocess(b)`
are executed in parallel.

`masked` is similar to `single`, except that it has no barrier at the end and it
always executes on the primary thread (thread 0), unless configured otherwise
with the `filter` clause.

== Tasks

```c
long fib_cut(int n) {
  // The cutoff allows executing the computation sequentially when the cost of
  // creating a new task becomes too large.
  if (n <= cutoff) return fib_serial(n);

  long x, y;
  // Create one task to execute in another thread and continue the other part of
  // the computation on the current thread.
  #pragma omp task shared(x) firstprivate(n)
  x = fib_cut(n - 1);
  y = fib_cut(n - 2);
  // Wait for the other task to complete.
  #pragma omp taskwait
  return x + y;
}

long fib(int n) {
  // Create the team of executor threads.
  #pragma omp parallel
  // `single` ensures that only one thread computes the final result.
  #pragma omp single
  return fib_cut(n);
}
```

`taskwait` only waits for the direct child tasks. To wait for every task in the
subtree, the task creation can be enclosed in a `#pragma omp taskgroup` region
instead.

= Synchronization mechanisms

- `barrier`: all team threads must finish their work before proceeding;
- `taskwait`: the current task must wait for its child tasks' results;
- `taskgroup`: all tasks in the subtree must finish;
- `critical` or `omp_lock_t`: guards exclusive access to a variable;
- `atomic`: a single indivisible memory operation (`update`/`capture`);

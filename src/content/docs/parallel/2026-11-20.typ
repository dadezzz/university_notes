#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Timing parallel kernels, choosing baselines, distinguishing strong from weak scaling, and summarizing results with means, medians, and confidence intervals.",
  lang: "en",
  title: "Benchmarking parallel programs: timing and scaling",
))

= Benchmarking

Benchmarking consists of collecting data to compare the performance gain or loss
caused by a change in the software or in the way it is deployed. The goal of
benchmarking is to find results that are reproducible, or at least
interpretable.

== Measurement

Timing measurements should include only the data-intensive part of the program,
not setup, I/O, or initialization. We should start collecting data only when all
threads are ready and stop when all have finished. If every thread times itself,
we should report the maximum time, not the average.

```c
#pragma omp parallel
{
  init();

  #pragma omp barrier // Wait for all threads to be ready.
  #pragma omp single
  t0 = omp_get_wtime(); // Use only monotonic clocks that never jump.

  parallel_kernel(); // Process the data.

  #pragma omp barrier // Wait for all threads to have finished.
  #pragma omp single
  t1 = omp_get_wtime();
}

elapsed_time = t1 - t0;
```

The first run of the program can often be slower due to cold caches and page
faults. It is important to perform warm-up runs, keeping track of how they were
performed and how many times.

=== Baselines

Measurements should be compared to both a serial version of the algorithm (which
is known to return correct results) and our parallel version with the number of
processors set to 1.

*Cost* is a metric for the overhead introduced by the parallelization of the
algorithm. The break-even point indicates how many threads it takes for the
parallel algorithm to become faster than the sequential one.

=== Strong vs. weak scaling

- Strong scaling refers to how the time to complete a fixed-size problem
  decreases as the number of processors increases. Ideally the time should
  decrease proportionally to the number of processors.
- Weak scaling involves increasing both the problem size and the number of
  processors, keeping the workload per processor constant. Ideally the time
  should be constant between runs.

=== Units

Some commonly used units are:

#table(
  columns: 2,
  table.header([*Unit*], [*Meaning*]),
  $upright("flop")$, [A count of floating-point operations, not a rate],
  $upright("flop" \/ s)$, [A rate: operations per second],
  $upright(G B)$, [$10^9$ bytes],
  $upright(G B \/ s)$, [Bandwidth in bytes per second],
)

== Presentation

Data must be summarized using statistics. Some common approaches are:

- Arithmetic mean: $(x_1 + dots.c + x_n) / n$, used for additive quantities such
  as time;
- Harmonic mean: $n / (1 / x_1 + dots.c + 1 / x_n)$, used for rates like
  $upright("flop" / s)$ or $upright(G B / s)$;
- Geometric mean: $(x_1 times dots.c times x_n)^(1 / n)$, used for speedup
  ratios, but it is better to average the times and then take the ratio;

Other considerations:

- Outliers should be kept and explained, since they are part of the behavior of
  the system.
- Use robust statistics such as the median and percentiles instead of the mean
  and standard deviation (median for time, 99th percentile for latency).
- For non-deterministic results, report a confidence interval.


#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  lang: "en",
  prev: false,
  title: "Lezione (2026-09-17)",
))

= Sequential vs parallel architectures

In serial computing a program is broken into a sequence of logic instructions,
executed one by one on a single processor. Only one instruction may execute at
any moment in time.

In the past, sequential programs could be made faster by simply waiting for some
time. Then, according to Moore's law, processors would get faster and we'd get a
free performance upgrade. Nowadays though we have hit the limits of this
scaling, and the solution is to split the work across multiple processor cores
executing concurrently.

Parallel hardware provides the resources needed to run concurrent programs.
Concurrent algorithms provide the work to exploit those resources.

Parallel computing is the simultaneous use of multiple resources to solve a
computational problem. A program is broken into discrete parts that can be
solved concurrently and multiple instructions are executed at any moment in
time, coordinated by some mechanism.

= Sequential vs parallel algorithms

Sequential algorithms are evaluated on the complexity required to accomplish a
certain task. That is the only metric that matters.

Adding parallelism introduces other metrics:

- *task parallelism*: how many jobs can execute at the same time;
- *data parallelism*: how many items can be modified in parallel by a single
  instruction;
- *scalability*: how much performance improves as the number of nodes increases;

There are two ways to make an algorithm parallel:

- *Data decomposition*: the data is decomposed into small chunks. Each
  processing element (PE) performs a specific task on a different portion of the
  data.
- *Task decomposition*: the problem is decomposed according to the subtasks of
  the work that must be done. Each PE performs a different task on a portion or
  on all the data.

= Amdahl's law

/ Concurrency: the number of activities whose execution can overlap in time
/ Parallelism: how many activities are actually executing simultaneously

Amdahl's law allows predicting how much a task will be sped up by parallelizing
it:

$
  T_p = s T_1 + (1 - s) T_1 / p
$

where $s$ is the serial fraction of the program and $1 - s$ is the perfectly
parallelizable part. $p$ is the number of processing elements.

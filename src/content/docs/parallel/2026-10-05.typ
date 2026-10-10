#import "../_templates/starlight.typ" as starlight;

#show: starlight.setup

#metadata((
  description: "Compares SIMD and MIMD designs, detailing array and vector processors plus performance issues from non-contiguous access, misalignment and branch divergence.",
  lang: "en",
  title: "SIMD and MIMD architectures: arrays and vectors",
))


= From one datapath to parallel architectures

Basic processor design includes one control unit that controls one datapath. In
typical SIMD architectures, a single control unit operates multiple datapaths,
enabling the application of the same instruction to multiple data registers.
MIMD architectures split the control unit, making each processing element
independent.

== SIMD architecture

The SIMD architecture allows performing parallel operations in an
energy-efficient way, since only one instruction has to be fetched per set of
data registers.

Execution is synchronous and deterministic, since the operation performed on
each datapath takes the same amount of time.

SIMD machines can be array processors, which employ several processing elements
(multiple datapaths) that operate in parallel, or vector processors, which apply
a single vectorized instruction to a vector register that holds multiple data
elements.

=== Array architectures

#starlight.img(
  "images/simd-array-arch.png",
  alt: "SIMD array architecture schema",
)

Each PE in an array consists of an ALU, local memory and other necessary
components.

Data is loaded into the PEs from the main memory, and after processing, results
are stored back. Each PE gets a contiguous chunk of data of size
$"total elements" / "number of datapaths"$.

```asm
; Each PE runs this loop on its local chunk of the arrays.
; y[i] = c * a[i] + b[i], with c in r5, &a in r6, &b in r7 and &y in r8.
mov r1, #0                 ; r1 is the loop index
mov r2, #16                ; r2 is the loop limit (16 elements per PE)

loop:
  ldr r3, [r6, r1, lsl #2] ; r3 = a[i]
  ldr r4, [r7, r1, lsl #2] ; r4 = b[i]
  mul r3, r3, r5           ; r3 = c * a[i]
  add r3, r3, r4           ; r3 = c * a[i] + b[i]
  str r3, [r8, r1, lsl #2] ; y[i] = r3
  add r1, r1, #1           ; increment the loop index
  cmp r1, r2               ; check if we've reached the loop limit
  bne loop
```

=== Vector architectures

#starlight.img(
  "images/simd-vector-arch.png",
  alt: "SIMD vector architecture schema",
)

Vector architectures rely on vector registers, with vectorized/pipelined
functional units.

Vector instructions allow leveraging memory bandwidth, since vector registers
can be filled with a single instruction that can fetch up to 128 bits of data.

```asm
; Vectorized version of the same loop, 4 elements per iteration.
; c is in r5 (broadcast to all lanes), &a in r6, &b in r7 and &y in r8.
mov r1, #0                 ; r1 is the loop index
mov r2, #4                 ; r2 is the loop limit (4 vectors of 4 elements)
vdup.32 q3, r5             ; q3 = {c, c, c, c}

loop:
  vld1.32 {q1}, [r6]!      ; q1 = a[i..i+3]
  vld1.32 {q2}, [r7]!      ; q2 = b[i..i+3]
  vmul.f32 q1, q1, q3      ; q1 = c * a[i..i+3]
  vadd.f32 q1, q1, q2      ; q1 = c * a[i..i+3] + b[i..i+3]
  vst1.32 {q1}, [r8]!      ; y[i..i+3] = q1
  add r1, r1, #1           ; increment the loop index
  cmp r1, r2               ; check if we've reached the loop limit
  bne loop
```

== Issues of SIMD architectures

Vector architectures load data in chunks into registers. If the memory access
patterns are irregular or inefficient, this can lead to performance degradation.

- Non-contiguous memory access: when data is scattered across memory, we may get
  cache misses, more memory accesses, and thus a higher latency. Array
  processors solve this with pipelining.
- Strided memory access: same as above, when there is a fixed gap between data
  and it is not aligned to the size of the vectors, we lose performance.
- Memory alignment: some architectures may require multiple loads/stores if the
  values in memory are not aligned to 16- or 32-byte boundaries.

Branch divergence is another problem with shared control units, since each PE
must execute the same instruction and must idle while the other branch executes.

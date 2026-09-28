#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Caching, row-major versus column-major access, SIMD vectorization and explicit prefetching improve memory performance and reduce CPU stalls on memory reads.",
  lang: "en",
  title: "Memory performance: caching, SIMD and prefetching",
))

= Memory performance

CPU compute speed far outpaces DRAM access latency, so on memory reads the CPU
stalls for hundreds of cycles.

Two mechanisms are used to improve performance: caching and overlapping memory
transfers with active computations.

== Row-major vs column-major access

Row-major access matches how array elements are stored in C, so they lie in a
contiguous block of memory and are accessed sequentially without jumps.

Column-major access reads elements in a non-contiguous way, reducing the number
of cache hits and thus resulting in poorer performance.

== From scalar processing to SIMD

A simple `for` loop fetches one element of the array at a time and puts it into
a CPU register. Then it usually applies an operation and writes the result back
to memory. This requires $n$ sequential loop operations for $n$ elements.

```c
void vec_add_scalar(float* A, float* B, float* C, int N) {
  for (int i = 0; i < N; i++) {
    C[i] = A[i] + B[i];
  }
}
```

SIMD instructions allow the compiler to vectorize the loop. The CPU can fetch
multiple elements in one instruction, stored in a larger register, and then
apply the same operation to each of them simultaneously.

```c
void vec_add_simd(float* A, float* B, float* C, int N) {
  for (int i = 0; i < N; i += 8) {
    __m256 a = _mm256_load_ps(A + i);
    __m256 b = _mm256_load_ps(B + i);
    __m256 c = _mm256_add_ps(a, b);
    _mm256_store_ps(C + i, c);
  }
}
```

This still has the problem of stalling the CPU while data is fetched into
registers, but the compiler can reorder instructions to keep the CPU busy while
the data is being fetched:

#starlight.img(
  "images/no-prefetch-vs-prefetch.png",
  alt: "Comparison with and without prefetching",
)

Prefetching can also be issued explicitly from the code:

```c
void vec_add_simd_prefetch(float* A, float* B, float* C, int N) {
  for (int i = 0; i < N; i += 8) {
    int pf = i + PFDIST_ELEMS;
    // Prefetch data into all cache levels.
    _mm_prefetch((char*)(A + pf), _MM_HINT_T0);
    _mm_prefetch((char*)(B + pf), _MM_HINT_T0);

    __m256 a = _mm256_load_ps(A + i);
    __m256 b = _mm256_load_ps(B + i);
    __m256 c = _mm256_add_ps(a, b);
    _mm256_store_ps(C + i, c);
  }
}
```

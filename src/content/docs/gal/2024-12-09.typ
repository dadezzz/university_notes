#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Criterio di diagonalizzabilità con corollari, matrici diagonalizzabili e cambiamento di base, endomorfismi simmetrici e teorema spettrale con base ortonormale.",
  lang: "it",
  next: false,
  title: "Criterio di diagonalizzabilità e teorema spettrale",
))

= Corollari del criterio di diagonalizzabilità

- Dati un endomorfismo $f: V -> V$, $dim(V) = n$ e i suoi autovalori
  $lambda_1, ..., lambda_k$, $k <= n$, allora:

  $
    f " è diagonalizzabile" <=> sum_(i = 1)^k a(lambda_i) = sum_(i = 1)^k g(lambda_i) = n
  $

- Dato un endomorfismo $f: V -> V$ tale che $chi_(f)(lambda)$ sia totalmente
  riducibile e tale che $a(lambda_i) = 1$ per ogni autovalore $lambda_i$, allora
  $f$ è diagonalizzabile.

- Dato un endomorfismo $f: V -> V$ diagonalizzabile, il determinante della
  matrice rappresentativa $bold(A)$ è il prodotto dei suoi autovalori, contati
  con la loro molteplicità algebrica:

  $
    det(bold(A)) = product_(i = 1)^k lambda_i^(a(lambda_i))
  $

= Matrici diagonalizzabili e cambiamento di base

Consideriamo un endomorfismo diagonalizzabile $f: V -> V$, una base $cal(A)$ di
$V$ e la matrice rappresentativa $bold(M)_cal(A)(f)$. Poiché $f$ è
diagonalizzabile, esiste una base di $V$ formata da autovettori di $f$.

Gli autovettori $bold(v)_1, ..., bold(v)_n$ di $f$ rappresentano le soluzioni
(non nulle) del sistema $(bold(M) - lambda bold(I)) bold(x) = bold(0)$.

Sia $cal(B) = {bold(v)_1, ..., bold(v)_n}$ una base di $V$, con
$bold(v)_i in E(lambda_i)$. Poiché $f(bold(v)_i) = lambda_i bold(v)_i$, la
matrice rappresentativa di $f$ rispetto a $cal(B)$ è la matrice diagonale con
gli autovalori sulla diagonale principale:

$
  bold(M)_(cal(B))(f) = op("diag")(lambda_1, ..., lambda_n) = mat(
    delim: "[",
    lambda_1, 0, dots.h, 0;
    0, lambda_2, dots.h, 0;
    dots.v, dots.v, dots.down, dots.v;
    0, 0, dots.h, lambda_n;
  )
$

La stessa matrice si ottiene con la formula del cambiamento di base:

$
  bold(M)_(cal(B))(f) = bold(M)_(cal(A))^(cal(B)) bold(M)_(cal(A))(f) bold(M)_(cal(B))^(cal(A))
$

= Endomorfismi simmetrici

Dati uno spazio vettoriale euclideo $V$ e un endomorfismo $f: V -> V$, $f$ è
simmetrico se:

$
  f(bold(v)) dot bold(w) = bold(v) dot f(bold(w))
$

Se $f$ è simmetrico e $lambda_1 != lambda_2$ sono autovalori distinti di $f$,
allora i vettori $bold(v)_1 in E(lambda_1)$, $bold(v)_2 in E(lambda_2)$ sono
ortogonali ($bold(v)_1 dot bold(v)_2 = bold(0)$). In altre parole, i vettori
appartenenti ad autospazi distinti sono ortogonali tra loro.

#starlight.tip([
  $f$ è simmetrico se e solo se la sua matrice rappresentativa rispetto a una
  base ortonormale è simmetrica, ovvero $[m_(i, j)] = [m_(j, i)]$.
])

= Teorema spettrale

Dati uno spazio vettoriale euclideo $V$ di dimensione finita e un endomorfismo
simmetrico $f: V -> V$, allora esiste una base ortonormale di $V$ fatta di
autovettori di $f$. In particolare $f$ è diagonalizzabile.

#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Diagonale principale, matrice trasposta e simmetrica, matrice nulla, riga e colonna; somma, prodotto per scalare e prodotto righe per colonne, matrice identità.",
  lang: "it",
  title: "Matrici trasposte, simmetriche e operazioni",
))

= Diagonale principale di una matrice

In una matrice di $m$ righe e $n$ colonne, l'insieme degli elementi
$a_(i, j) mid(|) i = j$ è detto diagonale principale della matrice.

= Matrici particolari

- *Matrice trasposta*: Data una matrice $bold(A) = [a_(i, j)]$, la matrice
  $bold(A)^T = [a_(j, i)]$ è detta matrice trasposta di $bold(A)$.

  In pratica si scambiano le righe con le colonne.

- *Matrice simmetrica*: Se $bold(A)$ è quadrata e coincide con la sua trasposta,
  allora essa è detta una matrice simmetrica (rispetto alla diagonale
  principale).

  Esempio:

  $
    bold(A) = bold(A)^T = mat(
      delim: "[",
      1, 2, 3;
      2, 3, 4;
      3, 4, 5;
    )
  $

- *Matrice nulla* : matrice i cui coefficienti sono tutti $0$. Si denota con
  $bold(0) = [0_(i, j)]$.

- *Matrice colonna*: è una matrice con una sola colonna.

- *Matrice riga*: è una matrice con una sola riga.

- *Matrice opposta*: la matrice opposta di $bold(A) = [a_(i, j)]$ è
  $- bold(A) = [-a_(i, j)]$.

= Operazioni tra matrici

== Somma

Si considerino due matrici $bold(A), bold(B) in bb(M)_(m, n)(bb(R))$ con
coefficienti $[a_(i, j)]$ e $[b_(i, j)]$ rispettivamente.

La somma delle due è la matrice:

$
  bold(C) = [a_(i, j) + b_(i, j)]
$

*Proprietà*:

- $bold(A) + bold(B) = bold(B) + bold(A)$
- $bold(A) + (bold(B) + bold(C)) = (bold(A) + bold(B)) + bold(C)$
- $bold(A) + bold(0) = bold(A)$

== Prodotto per uno scalare

Il prodotto tra la matrice $bold(A)$ e lo scalare $lambda$ è:

$
  bold(B) = [lambda a_(i, j)]
$

*Proprietà*:

- $lambda (mu bold(A)) = (lambda mu) bold(A)$
- $(lambda + mu) bold(A) = lambda bold(A) + mu bold(A)$
- $lambda (bold(A) + bold(B)) = lambda bold(A) + lambda bold(B)$
- $1 bold(A) = bold(A)$

== Prodotto di matrici

Una matrice $bold(A) in bb(M)_(m, n)(bb(R))$ è detta *conformabile a sinistra* a
una matrice $bold(B) in bb(M)_(n, p)(bb(R))$ perché il numero di colonne di
$bold(A)$ è uguale al numero di righe di $bold(B)$.

Il prodotto righe per colonne è una matrice $bold(C) in bb(M)_(m, p)(bb(R))$
dove:

$
  c_(i, k) = sum_(j = 1)^n a_(i, j) b_(j, k)
$

*Proprietà*:

Date $bold(A) in bb(M)_(n_1, n_2)(bb(R))$, $bold(B) in bb(M)_(n_2, n_3)(bb(R))$,
$bold(C) in bb(M)_(n_3, n_4)(bb(R))$:

- $(bold(A) bold(B)) bold(C) = bold(A) (bold(B) bold(C))$
- $lambda (bold(A) bold(B)) = (lambda bold(A)) bold(B) = bold(A) (lambda bold(B))$
- $bold(A) bold(I)_(n_2) = bold(A)$

Inoltre, se $bold(A), bold(B) in bb(M)_(m, n)(bb(R))$ e
$bold(C) in bb(M)_(n, p)(bb(R))$:

- $(bold(A) + bold(B)) bold(C) = bold(A) bold(C) + bold(B) bold(C)$

e, se $bold(A) in bb(M)_(m, n)(bb(R))$ e
$bold(B), bold(C) in bb(M)_(n, p)(bb(R))$:

- $bold(A) (bold(B) + bold(C)) = bold(A) bold(B) + bold(A) bold(C)$

#starlight.caution([
  Per il prodotto tra matrici non vale la proprietà commutativa.
])

= Matrice identità

La matrice identità è una matrice quadrata $bold(I) in bb(M)_(n, n)(bb(R))$ che
ha tutti i coefficienti uguali a $1$ sulla diagonale principale e $0$ altrove.

Una matrice identità di ordine 3 si denota così:

$
  bold(I)_3 = mat(
    delim: "[",
    1, 0, 0;
    0, 1, 0;
    0, 0, 1;
  )
$

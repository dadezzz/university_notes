#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Definizione del determinante tramite il teorema di Laplace, proprietà, teorema di Binet e metodo di Gauss; applicazioni: rango, invertibilità, teorema di Cramer e calcolo della matrice inversa.",
  lang: "it",
  title: "Determinante, teorema di Laplace e applicazioni",
))

= Determinante di una matrice quadrata

Sia $bold(A) in bb(M)_(n, n)(bb(R))$ una matrice quadrata. Dati due indici
$i, j in {1, ..., n}$, chiamiamo $bold(A)_(i, j)$ la matrice complementare di
dimensioni $(n - 1) times (n - 1)$ ottenuta da $bold(A)$ rimuovendo la riga $i$
e la colonna $j$.

Fissata una colonna $j$, il determinante di $bold(A)$ è il numero reale definito
tramite il teorema di Laplace:

$
  det(bold(A)) = sum_(i = 1)^n (-1)^(i + j) a_(i, j) det(bold(A)_(i, j))
$

La definizione è ricorsiva, perché ogni determinante di ordine $n$ si riduce a
determinanti di ordine $n - 1$.

#include "frames/determinante-area.typ"

== Casi particolari e proprietà del determinante

- Se $bold(A) in bb(M)_(1, 1)(bb(R))$, allora $det(bold(A)) = a_(1, 1)$.
- Se $bold(A) in bb(M)_(2, 2)(bb(R))$, allora
  $det(bold(A)) = a_(1, 1) a_(2, 2) - a_(1, 2) a_(2, 1)$.
- Se $bold(A)$ è una matrice triangolare superiore ($i > j => a_(i, j) = 0$),
  allora il determinante è il prodotto di tutti gli elementi sulla diagonale
  principale.
- Il determinante di $bold(I)_n$ è sempre $1$.
- Se $bold(A)$ ha una riga o una colonna nulla, allora $det(bold(A)) = 0$.
- $det(bold(A)) = det(bold(A)^T)$.

== Teorema di Binet

Se $bold(A), bold(B) in bb(M)_(n, n)(bb(R))$, allora:

$
  det(bold(A) bold(B)) = det(bold(A)) det(bold(B))
$

Quindi se $bold(A)$ è invertibile, allora
$det(bold(A)^(-1)) = (det(bold(A)))^(-1)$.

== Determinante delle matrici elementari

- $det(bold(S)_(i, j)) = -1$
- $det(bold(D)_(i)(lambda)) = lambda$
- $det(bold(E)_(i, j)(lambda)) = 1$

=== Metodo di Gauss per calcolare il determinante

È possibile calcolare il determinante di $bold(A)$ con i seguenti passaggi:

+ Ridurre $bold(A)$ a una forma a scalini $bold(A)'$ mediante le operazioni
  $bold(S)_(i, j)$ e $bold(E)_(i, j)(lambda)$.
+ Il determinante di $bold(A)'$ è il prodotto degli elementi sulla diagonale
  principale, perché una matrice a scalini è anche triangolare superiore.
+ $det(bold(A)) = (-1)^s det(bold(A)')$, dove $s$ è il numero di operazioni
  $bold(S)_(i, j)$ eseguite.

= Applicazioni del determinante

== Rango e invertibilità

Sia $bold(A) in bb(M)_(n, n)(bb(R))$ una matrice quadrata. Le seguenti
condizioni sono equivalenti:

- $det(bold(A)) != 0$
- $op("rg")(bold(A)) = n$
- $bold(A)$ è invertibile

Di conseguenza, un insieme di $n$ vettori ${bold(v)_1, ..., bold(v)_n}$ è una
base di $bb(R)^n$ se e solo se $det(bold(A)) != 0$, dove $bold(A)$ è la matrice
che ha tali vettori come colonne.

== Teorema di Cramer (sistemi lineari)

Sia $bold(A) bold(x) = bold(b)$ un sistema lineare quadrato di $n$ equazioni in
$n$ incognite. Se $det(bold(A)) != 0$, allora il sistema ammette un'unica
soluzione, data da:

$
  x_j = (det(bold(A)_j)) / (det(bold(A))), quad j = 1, ..., n
$

dove $bold(A)_j$ è la matrice ottenuta sostituendo la $j$-esima colonna di
$bold(A)$ con $bold(b)$.

== Calcolo delle matrici inverse

Sia $bold(A) in bb(M)_(n, n)(bb(R))$ con $bold(A) = [a_(i, j)]$. Il cofattore
dell'elemento $a_(i, j)$ è lo scalare:

$
  a'_(i, j) = (-1)^(i + j) det(bold(A)_(i, j))
$

La matrice dei cofattori di $bold(A)$ è $bold(A)' = [a'_(i, j)]$.

Se $bold(A)$ è invertibile, allora:

$
  bold(A)^(-1) = bold(A)'^T / det(bold(A))
$

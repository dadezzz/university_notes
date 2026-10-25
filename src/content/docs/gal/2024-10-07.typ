#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Soluzioni dei sistemi lineari omogenei e non omogenei, nucleo e nullità di una matrice, matrici elementari e criteri di invertibilità con calcolo dell'inversa.",
  lang: "it",
  title: "Sistemi lineari, nucleo e matrici invertibili",
))

= Insieme delle soluzioni di un sistema lineare

== Sistema omogeneo

Dato un sistema lineare omogeneo $bold(A) bold(x) = bold(0)$, si prendono 2
vettori $bold(v)$ e $bold(w)$ tali che siano soluzioni del sistema, ossia
$bold(A) bold(v) = bold(0)$ e $bold(A) bold(w) = bold(0)$.

Dati 2 scalari $lambda$ e $mu$, anche la combinazione lineare
$lambda bold(v) + mu bold(w)$ è soluzione del sistema.

*Dimostrazione*:

$
  bold(A) (lambda bold(v) + mu bold(w)) = lambda bold(A) bold(v) + mu bold(A) bold(w) = lambda bold(0) + mu bold(0) = bold(0)
$

#starlight.note([
  Ogni sistema lineare omogeneo è compatibile, in quanto ammette almeno la
  soluzione banale $bold(A) bold(0) = bold(0)$.
])

== Sistema non omogeneo

Dati un sistema lineare compatibile $bold(A) bold(x) = bold(b)$ e il suo sistema
lineare omogeneo associato $bold(A) bold(x) = bold(0)$, se $bold(x)_0$ è una
soluzione del sistema e $bold(v)$ è una soluzione del sistema omogeneo
associato, allora tutte le soluzioni di $bold(A) bold(x) = bold(b)$ sono della
forma $bold(x)_0 + bold(v)$, al variare di $bold(v)$ tra le soluzioni di
$bold(A) bold(x) = bold(0)$.

*Dimostrazione*:

$
  bold(A) (bold(x)_0 + bold(v)) = bold(A) bold(x)_0 + bold(A) bold(v) = bold(b) + bold(0) = bold(b)
$

Viceversa, sia $bold(x)$ una soluzione qualsiasi di $bold(A) bold(x) = bold(b)$.
Posto $bold(v) = bold(x) - bold(x)_0$, si ha

$
  bold(A) bold(v) = bold(A) bold(x) - bold(A) bold(x)_0 = bold(b) - bold(b) = bold(0),
$

#include "frames/soluzioni-sistema.typ"

= Nucleo di una matrice

Data una matrice $bold(A)$, il suo nucleo è l'insieme delle soluzioni del
sistema omogeneo $bold(A) bold(x) = bold(0)$.

Si definisce:

$
  ker(bold(A)) = {bold(x) in bb(R)^n mid(|) bold(A) bold(x) = bold(0)}
$

= Nullità di una matrice

Data una matrice $bold(A) in bb(M)_(m, n)$, la sua nullità è il numero di
colonne di $op("rref")(bold(A))$ che non contengono pivot, ovvero il numero
delle variabili libere del sistema $bold(A) bold(x) = bold(0)$. Si indica con:
$op("null")(bold(A))$.

#starlight.note([
  Il numero di colonne di $bold(A)$ è dato da
  $op("null")(bold(A)) + op("rg")(bold(A))$.
])

= Matrici delle operazioni elementari

Le operazioni elementari possono essere realizzate moltiplicando a sinistra per
opportune matrici quadrate, ottenute applicando l'operazione alla matrice
identità:

- $bold(I)_n arrow.r^(S_(i, j)) bold(S)_(i, j)$
- $bold(I)_n arrow.r^(D_(i)(lambda)) bold(D)_(i)(lambda)$
- $bold(I)_n arrow.r^(E_(i, j)(lambda)) bold(E)_(i, j)(lambda)$

= Matrici invertibili e inverse

L'invertibilità è una proprietà delle matrici quadrate.
$bold(A) in bb(M)_(n, n)(bb(R))$ è invertibile se:

$
  exists bold(B) in bb(M)_(n, n)(bb(R)) mid(|) bold(A) bold(B) = bold(B) bold(A) = bold(I)_n
$

In tale caso si dice che $bold(B)$ è la matrice inversa di $bold(A)$ e si denota
con: $bold(A)^(-1)$

Una matrice $bold(A) in bb(M)_(n, n)(bb(R))$ è invertibile se e solo se
$op("rg")(bold(A)) = n$. Infatti, se $op("rg")(bold(A)) < n$, la forma ridotta
$op("rref")(bold(A))$ contiene una riga nulla, quindi $bold(A)$ non è
invertibile.

Date $bold(A)$ e $bold(B)$ matrici invertibili, $bold(A) bold(B)$ è invertibile:

$
  (bold(A) bold(B))^(-1) = bold(B)^(-1) bold(A)^(-1)
$

== Inverse delle matrici elementari

- $(bold(I)_n)^(-1) = bold(I)_n$
- $(bold(S)_(i, j))^(-1) = bold(S)_(i, j)$
- $(bold(D)_(i)(lambda))^(-1) = bold(D)_(i)(lambda^(-1))$, con $lambda != 0$
- $(bold(E)_(i, j)(lambda))^(-1) = bold(E)_(i, j)(-lambda)$

== Come calcolare la matrice inversa

Per calcolare la matrice inversa di una matrice quadrata
$bold(A) in bb(M)_(n, n)(bb(R))$:

+ Si prende la matrice $bold(B) = (bold(A) mid(|) bold(I)_n)$, che ha dimensioni
  $n times 2 n$.
+ Si applicano operazioni elementari su $bold(B)$ per portarla nella sua forma
  ridotta per righe.
+ Se $bold(A)$ è invertibile, si ottiene:

  $
    op("rref")(bold(B)) = (bold(I)_n mid(|) bold(A)^(-1))
  $

== Matrici inverse e sistemi lineari

Si può usare una matrice inversa per trovare le soluzioni dei sistemi lineari:

$
  bold(A) bold(x) = bold(b) <=> bold(x) = bold(A)^(-1) bold(b)
$

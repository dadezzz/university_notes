#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Prodotto scalare e spazi vettoriali euclidei, disuguaglianza di Cauchy-Schwarz, norma, distanza, ortogonalità, proiezioni e basi ortonormali con Gram-Schmidt.",
  lang: "it",
  title: "Prodotto scalare, norma e basi ortonormali",
))

= Prodotto scalare in uno spazio vettoriale

Sia $V$ uno spazio vettoriale reale. Un prodotto scalare su $V$ è una funzione
che a ogni coppia $bold(v), bold(w) in V$ associa un numero reale
$bold(v) dot bold(w)$ tale che:

- $bold(v) dot bold(w) = bold(w) dot bold(v)$
- $(lambda bold(v)) dot bold(w) = lambda (bold(v) dot bold(w))$
- $bold(v) dot (bold(w) + bold(u)) = bold(v) dot bold(w) + bold(v) dot bold(u)$
- $bold(v) dot bold(v) >= 0$, con $bold(v) dot bold(v) = 0$ se e solo se
  $bold(v) = bold(0)$

= Spazio vettoriale euclideo

Uno spazio vettoriale dotato di prodotto scalare è detto spazio vettoriale
euclideo.

*Esempi*:

- $V^3$ spazio dei vettori geometrici.

- $bb(R)^n$ spazio delle ennuple.

  Il prodotto scalare canonico è definito come:

  $
    bold(v) dot bold(w) = sum_(i = 1)^n v_i w_i, bold(v), bold(w) in bb(R)^n
  $

- $M_(2, 2)(bb(R))$ spazio delle matrici quadrate di dimensione 2.

  Il prodotto scalare è definito come:

  $
    bold(A) dot bold(B) = op("Tr")(bold(B)^T bold(A))
  $

  $op("Tr")$ è la traccia di una matrice (definita solo per le matrici quadrate)
  e rappresenta la somma degli elementi che si trovano sulla diagonale
  principale.

== Disuguaglianza di Cauchy-Schwarz

Sia $V$ uno spazio vettoriale euclideo e siano $bold(v), bold(w) in V$; allora:

$
  (bold(v) dot bold(w))^2 <= (bold(v) dot bold(v)) (bold(w) dot bold(w))
$

= Norma di un vettore

La norma di un vettore è definita come:

$
  norm(bold(v)) = sqrt(bold(v) dot bold(v))
$

Essa è un numero reale maggiore o uguale a $0$, e $norm(bold(v)) = 0$ se e solo
se $bold(v) = bold(0)$.

La normalizzazione di un vettore $bold(v) != bold(0)$ è data da:

$
  bold(v) / norm(bold(v))
$

*Proprietà*:

- $norm(lambda bold(v)) = abs(lambda) norm(bold(v))$

- $norm(bold(v) + bold(w)) <= norm(bold(v)) + norm(bold(w))$

= Distanza tra due vettori

La distanza tra due vettori $bold(v)$ e $bold(w)$ è data da:

$
  d(bold(v), bold(w)) = norm(bold(v) - bold(w))
$

*Esempio*: polinomi $p(x), q(x) in bb(R)_2[x]$

$
  d(p(x), q(x)) = norm(p(x) - q(x)) = sqrt((p(x) - q(x)) (p(x) - q(x)))
$

*Proprietà*:

- $d(bold(v), bold(w)) >= 0$
- $d(bold(v), bold(w)) = 0 <=> bold(v) = bold(w)$
- $d(bold(v), bold(w)) = d(bold(w), bold(v))$
- $d(bold(v), bold(w)) <= d(bold(v), bold(u)) + d(bold(u), bold(w))$

= Ortogonalità tra due vettori

Sia $V$ uno spazio vettoriale euclideo; $bold(v)$ e $bold(w)$ sono ortogonali
se:

$
  bold(v) dot bold(w) = 0
$

*Esempio*: $bb(R)^2$ con prodotto scalare canonico
($bold(v) dot bold(w) = norm(bold(v)) norm(bold(w)) cos(alpha)$).

I due vettori sono ortogonali se e solo se $bold(v) = bold(0)$, oppure
$bold(w) = bold(0)$, oppure $cos(alpha) = 0$.

Sia $V$ uno spazio vettoriale euclideo. Se ${bold(v)_1, ..., bold(v)_n}$ è un
insieme di vettori non nulli ortogonali a coppie (ogni vettore è ortogonale a
ogni altro), allora ${bold(v)_1, ..., bold(v)_n}$ è linearmente indipendente.

Se $dim(V) = n$ e ${bold(v)_1, ..., bold(v)_n}$ sono vettori non nulli
ortogonali a coppie, allora essi formano una base di $V$.

= Proiezioni ortogonali

La proiezione ortogonale di un vettore $bold(v)$ su un vettore
$bold(u) != bold(0)$ è data dalla funzione lineare:

$
  op("pr")_(bold(u))(bold(v)) = (bold(u) dot bold(v)) / (bold(u) dot bold(u)) bold(u)
$

#include "frames/proiezione-ortogonale-2.typ"

= Base ortonormale

Sia $V$ uno spazio vettoriale euclideo. Un insieme ${bold(v)_1, ..., bold(v)_n}$
è ortonormale se:

$
  bold(v)_i dot bold(v)_j = delta_(i, j) = cases(
    i = j => 1,
    i != j => 0,
  )
$

dove $delta_(i, j)$ è il simbolo di Kronecker, applicato a tutte le coppie di
vettori $bold(v)_i, bold(v)_j$. Quindi un insieme è ortonormale se e solo se
tutti gli elementi sono ortogonali a coppie e la loro norma è pari a $1$.

== Ottenere una base ortonormale partendo da una base qualunque (metodo di Gram-Schmidt)

Dato un insieme di vettori linearmente indipendenti
${bold(v)_1, ..., bold(v)_n}$, costruiremo un insieme di vettori
${bold(a)_1, ..., bold(a)_n}$ tali che
$op("span")({bold(v)_1, ..., bold(v)_n}) = op("span")({bold(a)_1, ..., bold(a)_n})$,
cioè che generano lo stesso sottospazio.

I vettori ${bold(a)_1, ..., bold(a)_n}$ si ottengono in questo modo:

$
  bold(a)_1 & = bold(v)_1 \
  bold(a)_2 & = bold(v)_2 - op("pr")_(bold(a)_1)(bold(v)_2) \
     dots.v \
  bold(a)_i & = bold(v)_i - sum_(k = 1)^(i - 1) op("pr")_(bold(a)_k)(bold(v)_i)
$

Infine, una volta ottenuti i vettori ${bold(a)_1, ..., bold(a)_n}$, è necessario
normalizzarli affinché abbiano norma pari a $1$.

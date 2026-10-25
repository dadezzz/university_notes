#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Definizione di vettore geometrico, versore, vettore nullo e modulo; somma, prodotto per uno scalare, prodotto scalare, ortogonalità e proiezioni ortogonali.",
  lang: "it",
  prev: false,
  title: "Vettori geometrici, operazioni e prodotto scalare",
))

= Vettori geometrici

== Segmento orientato

Dati due punti $A$ e $B$ in uno spazio tridimensionale, un segmento orientato
$arrow(A B)$ è un segmento che ha come estremo iniziale il punto $A$ e come
estremo finale il punto $B$.

Due segmenti $arrow(A B)$ e $arrow(C D)$ sono equivalenti ($equiv$) se hanno la
stessa direzione, lo stesso modulo e lo stesso verso.

Un vettore geometrico è l'insieme dei segmenti orientati equivalenti tra loro:

$
  bold(v) = arrow(A B) = arrow(C D) " se " arrow(A B) equiv arrow(C D)
$

L'insieme dei vettori geometrici nello spazio tridimensionale si chiama $V^3$.

== Modulo di un vettore

Il modulo di un vettore $bold(v)$ ($norm(bold(v))$) è un numero sempre maggiore
o uguale a $0$, che rappresenta la lunghezza di un qualunque segmento orientato
che lo rappresenta.

Se $norm(bold(v)) = 0$ allora il vettore è nullo.

== Vettore nullo

Un vettore nullo è la classe di equivalenza del segmento orientato $arrow(A A)$,
dove l'estremo iniziale coincide con l'estremo finale. Direzione e verso sono
indeterminati.

Si indica con il simbolo $bold(0)$.

== Versore

Un versore è un vettore geometrico con modulo di valore $1$.

Di solito si indica con il simbolo $bold(e)$.

=== Normalizzazione di un vettore

La normalizzazione di un vettore è l'operazione che consiste nel trasformare un
vettore in un versore.

$
  bold(v) / norm(bold(v)) = bold(e) "se" bold(v) != bold(0)
$

== Operazioni tra vettori

=== Somma

Dati $bold(v) = arrow(A B)$ e $bold(w) = arrow(B C)$:

$
  bold(v) + bold(w) = arrow(A C)
$

*Proprietà*:

- $bold(v) + bold(w) = bold(w) + bold(v)$
- $(bold(v) + bold(w)) + bold(u) = bold(v) + (bold(w) + bold(u))$
- $bold(v) + bold(0) = bold(v)$

#include "frames/somma-vettori.typ"

=== Prodotto per uno scalare

Dato un vettore geometrico $bold(v)$ e uno scalare (numero reale) $lambda$, il
vettore geometrico $lambda bold(v)$ ha la stessa direzione di $bold(v)$, verso
uguale a quello di $bold(v)$ se $lambda > 0$ e opposto se $lambda < 0$, e modulo
$|lambda| norm(bold(v))$. Se $lambda = 0$, allora $lambda bold(v) = bold(0)$.

*Proprietà*:

- $lambda (mu bold(v)) = (lambda mu) bold(v)$
- $1 bold(v) = bold(v)$
- $(lambda + mu) bold(v) = lambda bold(v) + mu bold(v)$
- $lambda (bold(v) + bold(w)) = lambda bold(v) + lambda bold(w)$

=== Prodotto scalare

Il prodotto scalare tra due vettori $bold(v) = arrow(A B)$ e
$bold(w) = arrow(A C)$ è un numero reale dato da:

$
  bold(v) dot bold(w) = norm(bold(v)) norm(bold(w)) cos(alpha)
$

dove $alpha$ è l'angolo compreso tra i due vettori.

Se il prodotto scalare tra due vettori non nulli è $0$, allora essi sono
ortogonali.

*Proprietà*:

- $bold(v) dot bold(w) = bold(w) dot bold(v)$
- $(lambda bold(v)) dot bold(w) = lambda (bold(v) dot bold(w))$
- $bold(v) dot (bold(w) + bold(u)) = bold(v) dot bold(w) + bold(v) dot bold(u)$
- $bold(v) dot bold(v) = norm(bold(v))^2$

== Proiezioni ortogonali

Dati due vettori geometrici $bold(v)$ e $bold(w) != bold(0)$, la proiezione
ortogonale di $bold(v)$ su $bold(w)$ è:

$
  (bold(v) dot bold(w) / norm(bold(w))) bold(w) / norm(bold(w)) =
  ((bold(v) dot bold(w)) / norm(bold(w))^2) bold(w)
$

Se $norm(bold(w)) = 1$, allora si può scrivere:

$
  (bold(v) dot bold(w)) bold(w)
$

#include "frames/proiezione-ortogonale-1.typ"

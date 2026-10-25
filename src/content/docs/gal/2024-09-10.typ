#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Coordinate tridimensionali, operazioni tra vettori, equazioni cartesiane e parametriche di piani e rette nello spazio, fasci di piani generati da una retta.",
  lang: "it",
  title: "Vettori, piani e rette nello spazio cartesiano",
))

= Coordinate tridimensionali

Ogni punto in uno spazio ha 3 coordinate. Un vettore $arrow(A B)$ è composto da:

$
  (x_B - x_A, y_B - y_A, z_B - z_A)
$

== Decomposizione di un vettore sugli assi

Chiamiamo $bold(i)$, $bold(j)$ e $bold(k)$ i versori ortogonali tra loro e
paralleli agli assi cartesiani $x$, $y$ e $z$ rispettivamente. Le coordinate di
un vettore si possono scrivere come:

$
  bold(v) = v_1 bold(i) + v_2 bold(j) + v_3 bold(k)
$

oppure:

$
  bold(v) = (bold(v) dot bold(i), bold(v) dot bold(j), bold(v) dot bold(k))
$

#include "frames/vettore-coordinate.typ"

== Operazioni tra vettori con le coordinate

=== Somma

Dati $bold(v) = (v_1, v_2, v_3)$ e $bold(w) = (w_1, w_2, w_3)$:

$
  bold(v) + bold(w) = (v_1 + w_1, v_2 + w_2, v_3 + w_3)
$

=== Prodotto per uno scalare

Dati $bold(v) = (v_1, v_2, v_3)$ e $lambda in bb(R)$:

$
  lambda bold(v) = (lambda v_1, lambda v_2, lambda v_3)
$

=== Prodotto scalare

Dati $bold(v) = (v_1, v_2, v_3)$ e $bold(w) = (w_1, w_2, w_3)$:

$
  bold(v) dot bold(w) = v_1 w_1 + v_2 w_2 + v_3 w_3
$

== Modulo di un vettore

Dato $bold(v) = (v_1, v_2, v_3)$:

$
  norm(bold(v)) = sqrt(v_1^2 + v_2^2 + v_3^2)
$

= Equazioni di un piano nello spazio

== Equazione cartesiana

Un piano $pi$ nello spazio è determinato da un punto $P in pi$ e da un vettore
$bold(n)$ ortogonale a $pi$.

In altre parole, $pi$ è il luogo dei punti $Q = (x, y, z)$ dello spazio tali che
$arrow(P Q)$ è ortogonale a $bold(n)$.

Ricaviamo l'equazione cartesiana di $pi$.

+ Prendiamo $P = (x_P, y_P, z_P)$, $bold(n) = (n_1, n_2, n_3)$.
+ $arrow(P Q) = (x - x_P, y - y_P, z - z_P)$
+ $arrow(P Q) dot bold(n) = n_1 (x - x_P) + n_2 (y - y_P) + n_3 (z - z_P) = 0$

L'equazione cartesiana di $pi$ è $n_1 x + n_2 y + n_3 z + d = 0$ con
$d = -(n_1 x_P + n_2 y_P + n_3 z_P)$.

#include "frames/piano-normale.typ"

== Equazione parametrica

Dati 3 punti non allineati $A$, $B$, $C$ e il piano $pi$ che li contiene, siano
$bold(v) = arrow(A B)$ e $bold(w) = arrow(A C)$. Un punto $Q$ appartiene a $pi$
se e solo se $arrow(A Q)$ può risultare dalla combinazione lineare:

$
  arrow(A Q) = t bold(v) + s bold(w)
$

Si tratta quindi della somma di 2 vettori, uno con direzione uguale a $bold(v)$
e uno con direzione uguale a $bold(w)$, moltiplicati per 2 scalari $t$ e $s$
detti parametri.

L'equazione parametrica di $pi$ è:

$
  cases(
    x = x_A + t v_1 + s w_1,
    y = y_A + t v_2 + s w_2,
    z = z_A + t v_3 + s w_3,
  )
$

Risolvendo il sistema ed eliminando i parametri $t$ e $s$, si ottiene
un'equazione cartesiana di $pi$.

= Equazioni di rette nello spazio

== Equazione parametrica

Data una retta $r$ determinata da 2 punti distinti $A$ e $B$ e il suo vettore
direzionale $bold(v) = arrow(A B)$, un punto $Q$ appartiene a $r$ se e solo se
il vettore $arrow(A Q)$ ha la stessa direzione di $bold(v)$ (quindi
$arrow(A Q) = t bold(v)$, dove $t$ è un parametro).

L'equazione parametrica di $r$ è:

$
  cases(
    x = x_A + t v_1,
    y = y_A + t v_2,
    z = z_A + t v_3,
  )
$

Eliminando il parametro $t$ si ottengono 2 equazioni cartesiane: la retta è
l'intersezione di 2 piani.

#include "frames/retta-parametrica.typ"

= Fasci di piani

Data una retta $r$ con equazioni cartesiane:

$
  cases(
    a_1 x + b_1 y + c_1 z + d_1 = 0,
    a_2 x + b_2 y + c_2 z + d_2 = 0,
  )
$

Esiste un numero infinito di piani che contengono $r$. Questo insieme è detto
fascio di piani di sostegno $r$ ed è definito come:

$
  lambda (a_1 x + b_1 y + c_1 z + d_1) + mu (a_2 x + b_2 y + c_2 z + d_2) = 0
$

Per ogni coppia di scalari $(lambda, mu) != (0, 0)$ otteniamo l'equazione
cartesiana di un piano contenente la retta $r$.

#include "frames/fascio-piani.typ"

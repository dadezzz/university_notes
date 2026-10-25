#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Prodotto vettoriale con proprietà e versori, prodotto misto come volume, determinante per rette complanari e equazione cartesiana di un piano nello spazio.",
  lang: "it",
  title: "Prodotto vettoriale e misto, determinanti e piani",
))

= Prodotto vettoriale di segmenti orientati

Dati due vettori geometrici $bold(v), bold(w) in V^3$, il loro prodotto
vettoriale è il vettore $bold(u) = bold(v) times bold(w)$, con modulo
$norm(bold(u)) = norm(bold(v)) norm(bold(w)) sin(alpha)$ e dove $alpha$ è
l'angolo tra i due vettori.

Se $bold(v)$ e $bold(w)$ sono paralleli, cioè se $bold(v) = lambda bold(w)$ per
$lambda in bb(R)$, allora il prodotto vettoriale è $bold(0)$.

La direzione di $bold(u)$ è ortogonale sia a $bold(v)$ sia a $bold(w)$ e il
verso è dato dalla regola della mano destra ($bold(v)$ è il pollice, $bold(w)$
l'indice e $bold(u)$ il medio).

$norm(bold(v) times bold(w))$ è l'area del parallelogramma costruito sui due
vettori.

*Proprietà*:

Per ogni $bold(v), bold(w), bold(z) in V^3$ e $lambda in bb(R)$:

- $bold(v) times bold(w) = -bold(w) times bold(v)$
- $(lambda bold(v)) times bold(w) = bold(v) times (lambda bold(w)) = lambda (bold(v) times bold(w))$
- $(bold(v) + bold(w)) times bold(z) = bold(v) times bold(z) + bold(w) times bold(z)$
- $bold(v) times (bold(w) + bold(z)) = bold(v) times bold(w) + bold(v) times bold(z)$

== Versori e prodotto vettoriale

Siano $bold(i)$, $bold(j)$ e $bold(k)$ i tre versori degli assi cartesiani.

Calcoliamone i prodotti vettoriali:

- $bold(i) times bold(i) = bold(0)$
- $bold(i) times bold(j) = bold(k)$
- $bold(i) times bold(k) = -bold(j)$
- $bold(j) times bold(i) = -bold(k)$
- $bold(j) times bold(j) = bold(0)$
- $bold(j) times bold(k) = bold(i)$
- $bold(k) times bold(i) = bold(j)$
- $bold(k) times bold(j) = -bold(i)$
- $bold(k) times bold(k) = bold(0)$

#starlight.tip([
  L'ordine ciclico $bold(i) -> bold(j) -> bold(k)$, insieme alle sue rotazioni
  $bold(j) -> bold(k) -> bold(i)$ e $bold(k) -> bold(i) -> bold(j)$, dà segno
  $+$. L'ordine inverso $bold(k) -> bold(j) -> bold(i)$ dà segno $-$.
])

Dati $bold(v) = v_1 bold(i) + v_2 bold(j) + v_3 bold(k)$ e
$bold(w) = w_1 bold(i) + w_2 bold(j) + w_3 bold(k)$:

$
  bold(v) times bold(w) = (v_2 w_3 - v_3 w_2) bold(i) + (v_3 w_1 - v_1 w_3) bold(j) + (v_1 w_2 - v_2 w_1) bold(k)
$

Questa formula si può scrivere come il determinante della matrice:

$
  mat(
    delim: "[",
    bold(i), bold(j), bold(k);
    v_1, v_2, v_3;
    w_1, w_2, w_3;
  )
$

*Esempio*: calcolo dell'area di un triangolo

Dati i vertici $A = (1, 0, 1)$, $B = (3, 1, 1)$ e $C = (1, 1, 2)$:

#include "frames/area-triangolo.typ"

L'area si ottiene calcolando il modulo del prodotto vettoriale tra i vettori
$arrow(A B)$ e $arrow(A C)$ e dividendo per due:

$
  arrow(A B) = (2, 1, 0), quad arrow(A C) = (0, 1, 1)
$

$
  arrow(A B) times arrow(A C) = (1, -2, 2)
$

Quindi:

$
  text("Area") = 1/2 abs(arrow(A B) times arrow(A C)) = 1/2 sqrt(1^2 + (-2)^2 + 2^2) = 3/2
$

= Prodotto misto

Dati tre vettori geometrici $bold(v)$, $bold(w)$ e $bold(u)$, il prodotto misto
è lo scalare:

$
  bold(v) dot (bold(w) times bold(u))
$

Se $bold(v) = (v_1, v_2, v_3)$, $bold(w) = (w_1, w_2, w_3)$ e
$bold(u) = (u_1, u_2, u_3)$, allora il prodotto misto è uguale a:

$
  det mat(
    delim: "[",
    v_1, v_2, v_3;
    w_1, w_2, w_3;
    u_1, u_2, u_3;
  )
$

Il modulo del prodotto misto è il volume del parallelepipedo determinato dai tre
vettori.

#include "frames/parallelepipedo-prodotto-misto.typ"

= Determinante e rette complanari

Siano $r$ e $r'$ due rette, $bold(v)$ e $bold(w)$ i rispettivi vettori
direttori, $P in r$ e $Q in r'$. Le rette sono complanari se e solo se l'insieme
${bold(v), bold(w), arrow(P Q)}$ è linearmente dipendente, cioè se e solo se la
matrice $bold(M)$ che ha tali vettori come colonne ha determinante nullo:

$
  det(bold(M)) = 0
$

#include "frames/rette-complanari.typ"

= Determinante ed equazione cartesiana di un piano

Dati tre punti nello spazio non allineati $A$, $B$ e $C$, essi determinano in
maniera univoca un piano $pi$.

Per trovare un'equazione cartesiana del piano si definiscono i vettori
$arrow(A B)$ e $arrow(A C)$; il piano $pi$ è il luogo dei punti $Q$ tali che
$arrow(A Q)$ è una combinazione lineare di $arrow(A B)$ e $arrow(A C)$.

#include "frames/piano-tre-punti.typ"

Quindi $Q = (x, y, z) in pi$ se e solo se l'insieme
${arrow(A B), arrow(A C), arrow(A Q)}$ è linearmente dipendente, cioè se e solo
se:

$
  det mat(
    delim: "[",
    x - x_A, x_B - x_A, x_C - x_A;
    y - y_A, y_B - y_A, y_C - y_A;
    z - z_A, z_B - z_A, z_C - z_A;
  ) = 0
$

dove $A = (x_A, y_A, z_A)$, $B = (x_B, y_B, z_B)$ e $C = (x_C, y_C, z_C)$.

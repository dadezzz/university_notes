#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Formule per la distanza tra punti, piani e rette nello spazio, ennuple e loro operazioni, sistemi lineari, rappresentazione matriciale e operazioni elementari.",
  lang: "it",
  title: "Distanze nello spazio, ennuple, sistemi e matrici",
))

= Distanze nello spazio 3D

== Tra due punti

La distanza tra due punti $P = (x_P, y_P, z_P)$ e $Q = (x_Q, y_Q, z_Q)$ è data
dal modulo del vettore $arrow(P Q)$:

$
  d(P, Q) = norm(arrow(P Q)) = sqrt((x_Q - x_P)^2 + (y_Q - y_P)^2 + (z_Q - z_P)^2)
$

== Tra un punto e un piano

Dati un piano $pi$ con equazione cartesiana $n_1 x + n_2 y + n_3 z + d = 0$ e un
punto $P = (x_P, y_P, z_P) in.not pi$, la distanza tra $P$ e $pi$ è il valore
assoluto della proiezione del vettore $arrow(P Q)$ sulla direzione normale
$bold(n)$, con $Q$ punto qualsiasi di $pi$:

$
  d(P, pi) = norm(n_1 x_P + n_2 y_P + n_3 z_P + d) / sqrt(n_1^2 + n_2^2 + n_3^2)
$

#starlight.note([
  Se il punto $P$ appartiene a un piano parallelo a $pi$, allora si può usare
  questa formula anche per trovare la distanza tra i due piani.
])

#include "frames/distanza-punto-piano.typ"

== Tra un punto e una retta

Dati una retta $r$ con vettore direzionale $bold(v)$ e un punto $P in.not r$, si
trova la retta $s$ ortogonale ad $r$ e passante per $P$. Si trova il punto $Q$
di intersezione tra $r$ e $s$; la distanza è quella tra i due punti $P$ e $Q$.

Per trovare $Q$:

- Metodo 1:
  + Si sceglie un punto $Q(t) in r$ con coordinate date dalle equazioni
    parametriche di $r$. $Q(t)$ può scorrere sulla retta $r$ al variare di $t$.
  + Si trova $t$ tale che $arrow(P Q(t)) dot bold(v) = 0$.
  + Infine si calcola la distanza tra i due punti.

- Metodo 2:
  + Si trova il piano $pi$ ortogonale a $r$ e passante per $P$. $bold(v)$ è il
    vettore normale a $pi$ e il termine $d$ dell'equazione cartesiana si trova
    sostituendo in essa le coordinate di $P$.
  + $Q$ è il punto di intersezione tra $r$ e $pi$. Lo si trova inserendo le
    equazioni parametriche di $r$ al posto delle coordinate nell'equazione
    cartesiana di $pi$ (così basta estrarre il parametro $t$ dall'equazione).
  + Anche in questo caso si calcola la distanza tra i due punti.

== Tra due rette

Date due rette $r_1$ e $r_2$, $d(r_1, r_2)$ è la distanza minima tra un punto
qualsiasi di $r_1$ e un punto qualsiasi di $r_2$.

- Se le rette sono incidenti, la distanza è 0 perché c'è un punto in comune.
- Se sono parallele, si sceglie un punto qualsiasi di $r_1$ e si trova la sua
  distanza da $r_2$.
- Se sono sghembe:
  - Metodo 1: si trova il segmento $arrow(P Q)$ i cui estremi sono
    rispettivamente su $r_1$ e $r_2$ e che sia ortogonale ad entrambe le rette:

    $
      arrow(P(t) Q(s)) dot bold(v)_1 = 0 and arrow(P(t) Q(s)) dot bold(v)_2 = 0
    $

  - Metodo 2: si prende il fascio di piani avente sostegno $r_1$ e si trova il
    piano $pi$ parallelo a $r_2$. Poi si trova la distanza tra un punto
    qualsiasi appartenente a $r_2$ e $pi$.

#include "frames/distanza-rette-sghembe.typ"

= Ennuple

Lo spazio delle ennuple di dimensione $n$ è definito:

$
  bb(R)^n = { (v_1, ..., v_n) mid(|) v_i in bb(R), i = 1, ..., n }
$

In pratica esse generalizzano quanto già visto per i vettori geometrici, ma su
uno spazio di dimensione arbitraria.

== Operazioni tra ennuple

=== Somma

$
  bold(a) + bold(b) = (a_1 + b_1, ..., a_n + b_n)
$

=== Prodotto per uno scalare

$
  lambda bold(a) = (lambda a_1, ..., lambda a_n)
$

= Sistemi lineari

Un sistema di equazioni lineari (o sistema lineare) di $m$ equazioni in $n$
incognite è definito:

$
  cases(
    a_(1, 1) x_1 + ... + a_(1, n) x_n = b_1,
    dots.v,
    a_(m, 1) x_1 + ... + a_(m, n) x_n = b_m,
  )
$

Una soluzione del sistema lineare è un'ennupla $(x_1, ..., x_n)$ che sia
soluzione di tutte le $m$ equazioni.

Se il sistema non ammette soluzioni, esso è detto incompatibile. Un sistema
ammette infinite soluzioni se esiste almeno una variabile libera, ovvero
un'incognita che può assumere valori arbitrari e rispetto alla quale si
esprimono le altre.

Se $(b_1, ..., b_m) = bold(0)$, il sistema è detto omogeneo. Un sistema omogeneo
è sempre compatibile.

= Matrici

Lo spazio delle matrici di $m$ righe e $n$ colonne a coefficienti reali è
definito:

$
  bb(M)_(m, n)(bb(R)) = { mat(
      delim: "[",
      a_(1, 1), dots.h, a_(1, n);
      dots.v, , dots.v;
      a_(m, 1), dots.h, a_(m, n);
    ) mid(|) a_(i, j) in bb(R) }
$

$a_(i, j)$ è l'elemento sulla riga $i$ e colonna $j$.

È possibile riscrivere un sistema lineare sotto forma di matrici:

- matrice dei coefficienti:

  $
    bold(A) = mat(
      delim: "[",
      a_(1, 1), dots.h, a_(1, n);
      dots.v, , dots.v;
      a_(m, 1), dots.h, a_(m, n);
    )
  $

- matrice dei termini noti:

  $
    bold(b) = vec(
      delim: "[",
      b_1,
      dots.v;
      b_m,
    )
  $

- vettore delle incognite:

  $
    bold(x) = vec(
      delim: "[",
      x_1,
      dots.v;
      x_n,
    )
  $

Si chiama matrice completa di un sistema la matrice ottenuta affiancando alla
matrice $bold(A)$ la matrice $bold(b)$.

== Operazioni elementari sui sistemi lineari

Queste operazioni restituiscono sistemi lineari equivalenti a quello di
partenza, ovvero l'insieme delle soluzioni non cambia.

- scambio di posizione tra le righe $i$ e $j$: $S_(i, j)$
- moltiplicazione della riga $i$ per lo scalare $lambda != 0$: $D_(i)(lambda)$
- sostituzione della riga $i$ con la riga $i$ più $lambda$ volte la riga $j$:
  $E_(i, j)(lambda)$

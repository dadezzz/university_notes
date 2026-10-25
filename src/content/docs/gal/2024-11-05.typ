#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Spazi di colonne e righe di una matrice, rango come dimensione dello spazio delle righe, coordinate rispetto a una base, funzioni lineari e loro composizione.",
  lang: "it",
  title: "Spazi di righe e colonne, rango e funzioni lineari",
))

= Spazio delle colonne e spazio delle righe di una matrice

Data una matrice $bold(A) in bb(M)_(m, n)(bb(R))$, dove
$bold(c)_1, ..., bold(c)_n$ sono le sue colonne e $bold(r)_1, ..., bold(r)_m$ le
sue righe:

- $C(bold(A)) = op("span")({bold(c)_1, ..., bold(c)_n})$ è lo spazio delle
  colonne di $bold(A)$.
- $R(bold(A)) = op("span")({bold(r)_1, ..., bold(r)_m})$ è lo spazio delle righe
  di $bold(A)$.

Il rango $op("rg")(bold(A))$ è la dimensione dello spazio delle righe:

$
  dim(R(bold(A))) = op("rg")(bold(A))
$

= Coordinate di uno spazio vettoriale

Dato uno spazio vettoriale $V$, ogni suo elemento si può esprimere come
combinazione lineare:

$
  bold(v) = sum_(i = 1)^n v_i bold(b)_i
$

Gli scalari $v_1, ..., v_n$ sono detti *coordinate* di $bold(v)$ rispetto alla
base $cal(B) = {bold(b)_1, ..., bold(b)_n}$.

D'ora in poi chiameremo $T_(cal(B)): V -> bb(R)^n$ la funzione biunivoca e
lineare che associa ad ogni vettore di $V$ un'ennupla formata dalle coordinate
di quel vettore.

#include "frames/coordinate-base.typ"

= Funzioni lineari

Dati due spazi vettoriali $V$ e $V'$, una funzione da $V$ in $V'$ è detta
lineare se, per ogni $bold(v), bold(w) in V$ e per ogni $lambda, mu in bb(R)$:

$
  f(lambda bold(v) + mu bold(w)) = lambda f(bold(v)) + mu f(bold(w))
$

Gli spazi $V$ e $V'$ sono detti rispettivamente dominio e codominio di $f$. Se
$V = V'$ allora la funzione è detta endomorfismo.

Se una funzione lineare è biunivoca, essa viene detta isomorfismo; in tal caso
$V$ e $V'$ hanno la stessa dimensione e sono detti spazi isomorfi.

*Proprietà*:

- La funzione inversa di una funzione lineare biunivoca è anch'essa lineare.
- La composizione di due funzioni lineari è anch'essa una funzione lineare.

== Rappresentazione sotto forma di matrice

Una funzione lineare è *sempre rappresentata da una certa matrice*, che varia a
seconda della base scelta per il dominio e il codominio (più avanti vedremo come
trovare questa matrice rappresentativa).

Data una funzione lineare $f$ rappresentata da una matrice $bold(A)$, si ha:

$
  f(bold(v)) = bold(A) bold(v)
$

Una funzione lineare non è altro che la *moltiplicazione di un vettore per la
sua matrice rappresentativa*.

Se $V = V'$, la matrice rappresentativa è quadrata e $f$ è un endomorfismo; se
invece le dimensioni di dominio e codominio sono diverse, la matrice non è
quadrata.

== Composizione di funzioni lineari

La composizione di due funzioni lineari, ovvero l'applicazione di una
trasformazione $g$ al risultato della trasformazione $f$ del vettore $bold(v)$,
si scrive nel modo seguente:

$
  (g compose f)(bold(v)) = g(f(bold(v)))
$

In termini di matrici, se la funzione $g$ è rappresentata da una matrice
$bold(A)$ e la funzione $f$ è rappresentata da una matrice $bold(B)$, allora la
composizione è data dal prodotto delle due matrici rappresentative.

$
  (g compose f)(bold(v)) = bold(A) bold(B) bold(v)
$

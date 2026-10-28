#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Complemento ortogonale e formula della dimensione con il teorema nullità più rango, matrici ortogonali, isometrie e diagonalizzabilità tramite matrici simili.",
  lang: "it",
  title: "Matrici ortogonali, isometrie e diagonalizzazione",
))

= Complemento ortogonale

Dati $V$ e $S subset.eq V$, il complemento ortogonale $S^(perp)$ di $S$ è
definito come:

$
  S^(perp) = {bold(v) in V mid(|) bold(v) dot bold(s) = 0, forall bold(s) in S}
$

$S^(perp)$ è un sottospazio di $V$.

#include "frames/complemento-ortogonale.typ"

Se $S subset.eq V$ allora $dim(op("span")(S)) + dim(S^(perp)) = dim(V)$

*Dimostrazione*:

Consideriamo $op("span")(S)$ e una base ortonormale di $op("span")(S)$:
${bold(u)_1, ..., bold(u)_p}$.

Sia $f: V -> bb(R)^p$ una funzione definita ponendo
$f(bold(v)) = (bold(v) dot bold(u)_1, ..., bold(v) dot bold(u)_p)$.

- $f$ è lineare;
- $f$ è suriettiva;

Siccome ${f(bold(u)_1), ..., f(bold(u)_p)} = {bold(e)_1, ..., bold(e)_p}$ è una
base canonica di $bb(R)^p$, allora ogni $bold(w) in bb(R)^p$ è nell'immagine di
$f$ e quindi $op("Im")(f) = bb(R)^p$. In particolare
$dim(op("Im")(f)) = p = dim(op("span")(S))$.

$
  ker(f) = {bold(v) in V mid(|) f(bold(v)) = 0} = S^(perp)
$

Allora, per il teorema della nullità più rango:

$
  dim(V) = dim(ker(f)) + dim(op("Im")(f)) = dim(S^(perp)) + dim(op("span")(S))
$

= Matrici ortogonali

Una matrice quadrata $bold(A) in bb(M)_(n, n)(bb(R))$ è detta ortogonale se è
invertibile e se $bold(A)^(-1) = bold(A)^T$.

L'insieme delle matrici ortogonali si definisce come:

$
  O_(n, n)(bb(R)) = {bold(A) in bb(M)_(n, n)(bb(R)) mid(|) bold(A) bold(A)^T = bold(A)^T bold(A) = bold(I)_n}
$

Se $bold(A) in O_(n, n)(bb(R))$:

- $det(bold(A)) = plus.minus 1$ (per la definizione di $O_(n, n)(bb(R))$,
  $det(bold(A) bold(A)^T) = det(bold(I)_n) = det(bold(A)) det(bold(A)^T) = (det(bold(A)))^2$
  quindi $(det(bold(A)))^2 = 1$).
- Le colonne di $bold(A)$ sono una base ortonormale di $bb(R)^n$ rispetto al
  prodotto scalare canonico.

= Isometrie

Dato $V$ uno spazio vettoriale euclideo, una funzione lineare biunivoca
$f: V -> V$ è detta isometria se:

$
  forall bold(v), bold(w) in V, bold(v) dot bold(w) = f(bold(v)) dot f(bold(w))
$

Se $f$ è un'isometria:

- $norm(bold(v)) = norm(f(bold(v)))$
- $d(bold(v), bold(w)) = d(f(bold(v)), f(bold(w)))$
- la matrice rappresentativa di $f$ rispetto a una base ortonormale è
  ortogonale;

*Esempio*:

$f: bb(R)^2 -> bb(R)^2$ definita mandando $(x, y) in bb(R)^2$ in un punto a pari
distanza dall'origine, ruotato di un angolo $alpha$ in senso antiorario.

#include "frames/rotazione-piano.typ"

Sia $cal(B) = {(1, 0), (0, 1)}$ la base canonica ortonormale di $bb(R)^2$ e
$bold(M)_(cal(B))^(cal(B))(f) = mat(delim: "[", cos(alpha), -sin(alpha); sin(alpha), cos(alpha))$
la matrice rappresentativa di $f$.

Verifichiamo se $bold(M)_(cal(B))^(cal(B))(f)$ è ortogonale.

- è invertibile: $det(bold(M)) = (cos(alpha))^2 + (sin(alpha))^2 = 1$
- $bold(M) bold(M)^T = bold(M)^T bold(M) = bold(I)_n$

= Diagonalizzabilità

== Matrici simili

Due matrici $bold(A), bold(B) in bb(M)_(n, n)(bb(R))$ sono simili se esiste una
matrice invertibile $bold(C) in bb(M)_(n, n)(bb(R))$ tale che:

$
  bold(A) = bold(C)^(-1) bold(B) bold(C)
$

*Esempio*: due matrici rappresentative di uno stesso endomorfismo su basi
diverse ($bold(M)_(cal(A))^(cal(A))(f)$ e $bold(M)_(cal(B))^(cal(B))(f)$) sono
simili.

== Endomorfismo diagonalizzabile

Un endomorfismo $f: V -> V$ è detto diagonalizzabile se:

$
  exists cal(B) " base di " V mid(|) bold(M)_(cal(B))^(cal(B))(f) " è diagonale"
$

#starlight.note([
  Una matrice è diagonale se gli elementi al di fuori della diagonale principale
  sono tutti nulli.
])

Se $f: V -> V$ è diagonalizzabile e $cal(B) = {bold(b)_1, ..., bold(b)_n}$ è una
base di $V$ tale che $bold(M)_(cal(B))^(cal(B))(f)$ è diagonale, allora:

$
  f(bold(b)_1) = lambda_1 bold(b)_1 + ... + 0 bold(b)_n \
  dots.v \
  f(bold(b)_n) = 0 bold(b)_1 + ... + lambda_n bold(b)_n
$

ossia:

$
  f(bold(b)_i) = lambda_i bold(b)_i
$

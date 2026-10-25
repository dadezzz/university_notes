#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Base di uno spazio vettoriale finitamente generato, unicità della combinazione lineare e criteri tramite il rango della matrice per generatori e indipendenza.",
  lang: "it",
  title: "Basi di spazi vettoriali e rango di una matrice",
))

= Base di uno spazio vettoriale

Sia $V$ uno spazio vettoriale finitamente generato. Un insieme di vettori
$cal(B) = {bold(b)_1, ..., bold(b)_n}$ è detto base di $V$ se:

- è un insieme di generatori di $V$;
- è linearmente indipendente;

Ogni vettore $bold(v) in V$ si scrive in modo unico come combinazione lineare
dei vettori della base ${bold(b)_1, ..., bold(b)_n}$.

Dati un insieme di vettori ${bold(v)_1, ..., bold(v)_n} subset.eq bb(R)^m$ e la
matrice
$bold(A) = mat(delim: "[", bold(v)_1, dots.h, bold(v)_n) in bb(M)_(m, n)(bb(R))$:

- ${bold(v)_1, ..., bold(v)_n} in bb(R)^m$ è un sistema di generatori di
  $bb(R)^m$ se e solo se $op("rg")(bold(A)) = m$, con $n >= m$.
- ${bold(v)_1, ..., bold(v)_n} in bb(R)^m$ è linearmente indipendente se e solo
  se $op("rg")(bold(A)) = n$, con $n <= m$.
- ${bold(v)_1, ..., bold(v)_n} in bb(R)^m$ è una base di $bb(R)^m$ se e solo se
  $op("rg")(bold(A)) = m = n$.

#include "frames/base-r3.typ"

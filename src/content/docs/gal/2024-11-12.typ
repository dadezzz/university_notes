#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Nucleo e immagine di una funzione lineare: proprietà equivalenti, criteri di iniettività e suriettività, matrice rappresentativa e teorema nullità più rango.",
  lang: "it",
  title: "Nucleo, immagine e teorema nullità più rango",
))

= Nucleo di una funzione lineare

Data una funzione lineare $f: V -> V'$, il nucleo di $f$ è definito come:

$
  ker(f) = {bold(v) mid(|) f(bold(v)) = bold(0)}
$

$ker(f)$ è un sottospazio di $V$.

*Proprietà equivalenti*:

- $ker(f) = {bold(0)}$
- $f$ è iniettiva.
- Se ${bold(v)_1, ..., bold(v)_k}$ è linearmente indipendente, allora anche
  ${f(bold(v)_1), ..., f(bold(v)_k)}$ lo è.

Il nucleo di una funzione lineare corrisponde, tramite la mappa delle
coordinate, al nucleo della sua matrice rappresentativa.

= Immagine di una funzione lineare

Data una funzione lineare $f: V -> V'$, l'immagine di $f$ è l'insieme dei
vettori di $V'$ che sono immagini dei vettori di $V$:

$
  op("Im")(f) = {bold(v)' in V' mid(|) exists bold(v) in V mid(|) f(bold(v)) = bold(v)'} subset.eq V'
$

$op("Im")(f)$ è un sottospazio di $V'$.

Se $f: V -> V'$ è lineare e suriettiva, allora $op("Im")(f) = V'$.

*Proprietà equivalenti*:

- $op("Im")(f) = V'$.
- $f$ è suriettiva.
- Se ${bold(v)_1, ..., bold(v)_k}$ è un sistema di generatori di $V$, allora
  ${f(bold(v)_1), ..., f(bold(v)_k)}$ è un sistema di generatori di $V'$.

L'immagine di una funzione lineare corrisponde, tramite la mappa delle
coordinate nel codominio, allo spazio generato dalle colonne della sua matrice
rappresentativa.

#include "frames/nucleo-immagine.typ"

= Teorema nullità più rango

Data una funzione lineare $f: V -> V'$ con $V$ di dimensione finita:

$
  dim(V) = dim(ker(f)) + dim(op("Im")(f))
$

Se $f: V -> V'$ è un isomorfismo, allora $dim(V) = dim(V')$.

#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Definizione di spazio vettoriale reale, combinazioni lineari, sottospazi vettoriali e sistemi di generatori, con il criterio del rango per le ennuple.",
  lang: "it",
  title: "Spazi vettoriali, combinazioni lineari e span",
))

= Spazi vettoriali

Uno spazio vettoriale reale è un insieme $V$ (i cui elementi sono detti vettori)
su cui sono definite due operazioni che soddisfano determinate proprietà:

- somma tra elementi qualsiasi di $V$:
  - $bold(v) + bold(w) = bold(w) + bold(v)$
  - $(bold(v) + bold(w)) + bold(u) = bold(v) + (bold(w) + bold(u))$
  - $exists bold(0) in V mid(|) bold(0) + bold(v) = bold(v)$
  - $bold(v) + (-bold(v)) = bold(0)$
- prodotto di un elemento di $V$ per uno scalare:
  - $lambda (mu bold(v)) = (lambda mu) bold(v)$
  - $1 bold(v) = bold(v)$
  - $(lambda + mu) bold(v) = lambda bold(v) + mu bold(v)$
  - $lambda (bold(v) + bold(w)) = lambda bold(v) + lambda bold(w)$

#starlight.note([
  Tutti i tipi di vettori visti finora soddisfano queste proprietà:

  - vettori geometrici (classe di equivalenza di segmenti orientati);
  - matrici;
  - ennuple (elementi di $bb(R)^n$);
])

= Combinazioni lineari

Dato uno spazio vettoriale reale $V$, considerati i vettori
$bold(v)_1, ..., bold(v)_k in V$ e gli scalari $lambda_1, ..., lambda_k$, il
vettore:

$
  bold(v) = sum_(i = 1)^k lambda_i bold(v)_i
$

è detto combinazione lineare dei vettori $bold(v)_1, ..., bold(v)_k$ con
coefficienti $lambda_1, ..., lambda_k$ e appartiene a $V$.

== Forma matriciale

La combinazione lineare $sum_(i = 1)^k lambda_i bold(v)_i$ si può scrivere sotto
forma di prodotto tra matrici. Detta $bold(A)$ la matrice che ha come colonne i
vettori $bold(v)_1, ..., bold(v)_k$:

$
  bold(A) = mat(delim: "[", bold(v)_1, dots.h, bold(v)_k), quad
  sum_(i = 1)^k lambda_i bold(v)_i = bold(A) mat(
    delim: "[",
    lambda_1;
    dots.v;
    lambda_k;
  )
$

Il risultato è quindi il vettore riga dato dal prodotto tra la matrice $bold(A)$
e il vettore colonna degli scalari $lambda_1, ..., lambda_k$.

= Sottospazi vettoriali

Un sottoinsieme $U$ dello spazio vettoriale $V$, $U subset.eq V$, è detto
sottospazio di $V$ se è chiuso rispetto alle due operazioni di $V$, ovvero se la
somma di due elementi di $U$ e il prodotto di un elemento di $U$ per uno scalare
danno come risultato un altro elemento di $U$.

Di conseguenza, una combinazione lineare di elementi di un sottospazio deve
restituire un altro elemento di quel sottospazio.

$
  forall bold(u)_1, bold(u)_2 in U, forall lambda, mu in bb(R), quad
  lambda bold(u)_1 + mu bold(u)_2 in U
$

Se $U$ è un sottospazio di $V$ allora $bold(0) in U$, per le proprietà del
prodotto di un elemento di $V$ per lo scalare $0$.

Se $exists bold(u) in U mid(|) bold(u) != bold(0)$, allora $U$ contiene infiniti
elementi, dati da $lambda bold(u)$ al variare di $lambda in bb(R)$.

*Esempio*: sottospazi di $bb(R)^n$:

- ${bold(0)}$: insieme formato solo dal vettore nullo;
- $bb(R)^n$: lo spazio stesso è un sottospazio di sé;
- ${bold(v) mid(|) bold(A) bold(v) = bold(0)}$: insieme delle soluzioni di un
  sistema lineare omogeneo;
- ${bold(v) = (0, v_2, ..., v_n)}$: insieme delle ennuple in cui il primo
  elemento è $0$;

= Generatori di uno spazio vettoriale

Dato uno spazio vettoriale reale $V$ e dei vettori
$bold(v)_1, ..., bold(v)_k in V$, l'insieme di tutte le combinazioni lineari di
$bold(v)_1, ..., bold(v)_k$ è detto spazio generato da
$bold(v)_1, ..., bold(v)_k$.

Si definisce:

$
  op("span")(bold(v)_1, ..., bold(v)_k) = {sum_(i = 1)^k lambda_i bold(v)_i " con " lambda_i in bb(R)}
$

Se esistono $bold(v)_1, ..., bold(v)_k in V$ tali che
$V = op("span")(bold(v)_1, ..., bold(v)_k)$, allora si dice che $V$ è
finitamente generato e che ${bold(v)_1, ..., bold(v)_k}$ è un sistema di
generatori di $V$.

#include "frames/span-r3.typ"

== Stabilire se un insieme di ennuple è un sistema di generatori di $bb(R)^n$

L'insieme di ennuple ${bold(v)_1, ..., bold(v)_k}$ è un insieme di generatori di
$bb(R)^n$ se e solo se:

$
  op("rg")(bold(A)) = n " con " bold(A) = mat(delim: "[", bold(v)_1, dots.h, bold(v)_k)
$

Per avere rango $n$, è necessario che $k >= n$.

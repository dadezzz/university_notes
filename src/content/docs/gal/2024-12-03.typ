#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Definizioni di autovettore, autovalore e spettro; polinomio caratteristico, autospazi, molteplicità algebrica e geometrica e criterio di diagonalizzabilità.",
  lang: "it",
  title: "Autovettori, autovalori e diagonalizzazione",
))

= Autovettori e autovalori

Dato un endomorfismo $f: V -> V$, un vettore $bold(v) in V$, con
$bold(v) != bold(0)$, è detto *autovettore* se:

$
  exists lambda in bb(R) mid(|) f(bold(v)) = lambda bold(v)
$

Uno scalare $lambda$ è detto *autovalore* se:

$
  exists bold(v) in V, bold(v) != bold(0) mid(|) f(bold(v)) = lambda bold(v)
$

L'insieme degli autovalori di $f$ si chiama *spettro di $f$*.

Dato un autovalore $lambda$, l'autospazio relativo a $lambda$ è il sottospazio
di $V$:

$
  E(lambda) = {bold(v) in V mid(|) f(bold(v)) = lambda bold(v)}
$

Dati $lambda_1, ..., lambda_k$ autovalori distinti di $f$ e
$bold(v)_1, ..., bold(v)_k in V$ autovettori non nulli tali che
$f(bold(v)_i) = lambda_i bold(v)_i$, allora l'insieme
${bold(v)_1, ..., bold(v)_k}$ è linearmente indipendente.

*Esempio*: $f: bb(R)^2 -> bb(R)^2$, $f: (v_1, v_2) -> (v_2, v_1)$

- $lambda = 1$ è un autovalore di $f$, con autovettore $bold(v) = (1, 1)$.
  Allora $bold(v) in E(1)$ perché $f(bold(v)) = 1 bold(v)$.
- $lambda = -1$ è un autovalore di $f$, con autovettore $bold(v) = (1, -1)$.
  Allora $bold(v) in E(-1)$ perché $f(bold(v)) = -1 bold(v)$.

#include "frames/autovettori.typ"

== Come trovare gli autovalori di $f$

Dati un qualunque endomorfismo $f: V -> V$, una base $cal(A)$ di $V$ e la
matrice rappresentativa $bold(M) = bold(M)_cal(A)(f)$, $lambda$ è un autovalore
di $f$ se e solo se esiste $bold(v) != bold(0)$ tale che
$f(bold(v)) = lambda bold(v)$, ovvero:

$
  bold(M) bold(v) = lambda bold(I) bold(v)
  <=>
  (bold(M) - lambda bold(I)) bold(v) = bold(0)
  <=>
  det(bold(M) - lambda bold(I)) = 0
$

Il *polinomio caratteristico* di $f$ è il polinomio con variabile $lambda$:

$
  chi_(f)(lambda) = det(bold(M) - lambda bold(I))
$

Se prendiamo una base diversa da $cal(A)$, il polinomio non cambia. Gli
autovalori e i rispettivi autovettori sono utili per descrivere un'applicazione
lineare a prescindere dalla base usata, cosa che non è vera per le matrici
rappresentative rispetto ad una base.

$f$ è diagonalizzabile se e solo se esiste una base di $V$ formata da
autovettori di $f$.

== Come trovare gli autovettori di $f$

Sia $lambda_i$ un autovalore di $f$, allora:

$
  f(bold(v)) = lambda_i bold(v) \
  arrow.t.b.double \
  f(bold(v)) - lambda_i op("Id")(bold(v)) = bold(0) \
  arrow.t.b.double \
  (f - lambda_i op("Id"))(bold(v)) = bold(0) \
  arrow.t.b.double \
  (bold(M) - lambda_i bold(I)) bold(v) = bold(0)
$

Quindi:

$
  E(lambda_i) = {bold(v) mid(|) f(bold(v)) = lambda_i bold(v)} = ker(f - lambda_i op("Id"))
$

#starlight.note([
  $op("Id")$ è una funzione lineare che lascia invariato il vettore. Quindi la
  sua matrice rappresentativa è $bold(I)$.
])

= Molteplicità geometrica e molteplicità algebrica

Sia $lambda_0$ un autovalore di $f$:

- La molteplicità algebrica di $lambda_0$, $a(lambda_0)$, è la molteplicità di
  $lambda_0$ come radice di $chi_(f)(lambda)$, ovvero quante volte compare il
  fattore $(lambda - lambda_0)$ nel polinomio.
- La molteplicità geometrica di $lambda_0$, $g(lambda_0)$, è la dimensione
  dell'autospazio $E(lambda_0)$.

Per ogni autovalore vale:

$
  1 <= g(lambda_0) <= a(lambda_0)
$

= Criterio di diagonalizzabilità

$f: V -> V$ è un endomorfismo diagonalizzabile se e solo se:

- $chi_(f)(lambda)$ è totalmente riducibile (fattorizzabile come prodotto di
  polinomi di grado 1).
- Per ogni autovalore $lambda_i$ si ha $a(lambda_i) = g(lambda_i)$.

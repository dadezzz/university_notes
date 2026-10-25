#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Costruzione della matrice rappresentativa di una funzione lineare rispetto a basi date, cambiamento di base e formula per esprimerla in basi arbitrarie.",
  lang: "it",
  title: "Matrici rappresentative e cambiamento di base",
))

= Matrici rappresentative di funzioni lineari

Data una funzione lineare qualsiasi, si può trovare una matrice che la
rappresenta rispetto a una base di partenza del dominio e a una di arrivo del
codominio.

#starlight.note([
  La matrice rappresentativa descrive la funzione solo rispetto a una
  determinata coppia di basi; per gli endomorfismi diagonalizzabili vedremo più
  avanti come scegliere una base di autovettori che semplifica la matrice.
])

== Come costruire la matrice rappresentativa di una funzione $f: V -> V'$

Date due basi:

- $cal(A) = {bold(a)_1, ..., bold(a)_n} subset.eq V$
- $cal(B) = {bold(b)_1, ..., bold(b)_m} subset.eq V'$

In pratica, le colonne della matrice rappresentativa contengono le coordinate,
rispetto alla base $cal(B)$, delle immagini $f(bold(a)_i)$ dei vettori della
base $cal(A)$. Quindi la matrice rappresentativa descrive dove finiscono i
vettori di $cal(A)$ dopo che è stata applicata loro la trasformazione $f$.

Determiniamo i coefficienti $alpha_(i, j)$ della matrice:

$
  f(bold(a)_1) = sum_(i = 1)^m alpha_(i, 1) bold(b)_i \
  dots.v \
  f(bold(a)_n) = sum_(i = 1)^m alpha_(i, n) bold(b)_i
$

Chiamiamo $bold(M)_(cal(A))^(cal(B))(f)$ la matrice rappresentativa di $f$
rispetto alle basi $cal(A)$ (del dominio) e $cal(B)$ (del codominio).

$
  bold(M)_(cal(A))^(cal(B))(f) = mat(
    delim: "[",
    alpha_(1, 1), dots.h, alpha_(1, n);
    dots.v, , dots.v;
    alpha_(m, 1), dots.h, alpha_(m, n);
  )
$

Se le basi di partenza e di arrivo coincidono, allora si può anche scrivere
$bold(M)(f)$.

== Coordinate e matrici rappresentative

Se una funzione lineare $f$ è definita su uno spazio vettoriale diverso da
quello delle ennuple, dove la moltiplicazione per la matrice rappresentativa
potrebbe risultare difficile o non essere definita, è possibile applicare la
trasformazione all'ennupla $bold(w)$ delle coordinate di quel vettore e poi
riconvertire l'ennupla nel corrispondente vettore del codominio di $f$.

$
  mat(
    delim: #none,
    V, arrow.r^(f(bold(v))), V';
    arrow.b, , arrow.b;
    T_(cal(A)), , T_(cal(B));
    arrow.b, , arrow.b;
    bb(R)^n, arrow.r^(bold(M) bold(w)), bb(R)^m;
  )
$

Visto il diagramma sopra, il procedimento da seguire è
$f(bold(v)) = (T_(cal(B)))^(-1) bold(M) T_(cal(A))(bold(v))$, dove $T_(cal(A))$
converte $bold(v)$ nell'ennupla delle coordinate rispetto alla base $cal(A)$ e
$(T_(cal(B)))^(-1)$ riconverte l'ennupla delle coordinate rispetto alla base
$cal(B)$ in un vettore del codominio.

*Corollario*:

- $ker(bold(M)) = T_(cal(A))(ker(f))$ e
  $ker(f) = (T_(cal(A)))^(-1)(ker(bold(M)))$
- $op("span")(C(bold(M))) = T_(cal(B))(op("Im")(f))$ e
  $op("Im")(f) = (T_(cal(B)))^(-1)(op("span")(C(bold(M))))$

= Cambiamento di base

Abbiamo visto che un vettore appartenente ad uno spazio vettoriale $V$ è
rappresentato da un'unica combinazione lineare rispetto ad una base scelta di
$V$. Le coordinate del vettore sono i coefficienti di questa combinazione
lineare.

Per rappresentare lo stesso vettore rispetto a un'altra base di $V$ è necessario
rimappare le sue coordinate. Questa operazione è detta cambiamento di base.

Sia $bold(v) in V$, quindi posso scriverlo come combinazione lineare degli
elementi di una base $cal(A) = {bold(a)_1, ..., bold(a)_n}$ oppure come un'altra
combinazione lineare (a coefficienti ovviamente differenti) di un'altra base
$cal(B) = {bold(b)_1, ..., bold(b)_n}$:

$
  bold(v) = sum_(i = 1)^n lambda_i bold(a)_i = sum_(i = 1)^n mu_i bold(b)_i
$

Chiamo $bold(M)_(cal(A))^(cal(B))$ la matrice che mette in relazione le
coordinate rispetto alla base $cal(A)$ con quelle rispetto alla base $cal(B)$.
Posso passare dalle coordinate rispetto alla base $cal(A)$ a quelle rispetto
alla base $cal(B)$ moltiplicando il vettore delle coordinate per
$bold(M)_(cal(A))^(cal(B))$:

$
  bold(M)_(cal(A))^(cal(B)) mat(delim: "[", lambda_1; dots.v; lambda_n) = mat(
    delim: "[",
    mu_1;
    dots.v;
    mu_n;
  )
$

Per il cambiamento inverso posso usare la matrice inversa di
$bold(M)_(cal(A))^(cal(B))$:

$
  bold(M)_(cal(B))^(cal(A)) = (bold(M)_(cal(A))^(cal(B)))^(-1)
$

#include "frames/cambiamento-base.typ"

= Come trovare la matrice rappresentativa di una funzione rispetto a basi arbitrarie

Sia $f: bb(R)^n -> bb(R)^m$ una funzione lineare rappresentata dalla matrice
$bold(M)_(cal(A))^(cal(A)')(f)$.

Supponiamo di voler trovare $bold(M)_(cal(B))^(cal(B)')(f)$, matrice
rappresentativa di $f$ rispetto alle basi $cal(B)$ di $bb(R)^n$ e $cal(B)'$ di
$bb(R)^m$, partendo da $bold(M)_(cal(A))^(cal(A)')(f)$.

Per una funzione lineare vale il seguente diagramma: nella parte superiore, la
funzione è definita da una matrice rispetto alle basi $cal(A)$ e $cal(A)'$ di
$bb(R)^n$ e $bb(R)^m$ rispettivamente; in quella inferiore, la stessa funzione è
definita rispetto ad altre due basi del dominio ($cal(B)$) e del codominio
($cal(B)'$):

$
  mat(
    delim: #none,
    bb(R)^n, arrow.r^(bold(M)_(cal(A))^(cal(A)')(f)), bb(R)^m;
    arrow.b, , arrow.b;
    bold(M)_(cal(A))^(cal(B)), , bold(M)_(cal(A)')^(cal(B)');
    arrow.b, , arrow.b;
    bb(R)^n, arrow.r^(bold(M)_(cal(B))^(cal(B)')(f)), bb(R)^m;
  )
$

Dal diagramma consegue che
$bold(M)_(cal(B))^(cal(B)')(f) = bold(M)_(cal(A)')^(cal(B)') bold(M)_(cal(A))^(cal(A)')(f) (bold(M)_(cal(A))^(cal(B)))^(-1)$.
Ovvero, se voglio applicare la funzione rappresentata da
$bold(M)_(cal(A))^(cal(A)')(f)$ a un vettore dato in coordinate rispetto alla
base $cal(B)$, posso calcolare le sue coordinate rispetto alla base $cal(A)$,
applicare la trasformazione lineare e poi riconvertire il vettore nelle
coordinate rispetto alla base $cal(B)'$.

#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Spazi di righe e colonne, sistemi lineari omogenei associati ai sottospazi, polinomi come spazi vettoriali, esempi, controesempi e indipendenza lineare.",
  lang: "it",
  title: "Spazi riga e colonna, sistemi lineari e polinomi",
))

= Sottospazio delle righe e delle colonne di una matrice

Data una matrice $bold(A) in bb(M)_(m, n)(bb(R))$, le sue righe e le sue colonne
sono vettori dello spazio delle ennuple:

$
  {bold(r)_1, ..., bold(r)_m} subset bb(R)^n and {bold(c)_1, ..., bold(c)_n} subset bb(R)^m
$

Il sottospazio generato dalle righe di $bold(A)$ si denota con:

$
  R(bold(A)) = op("span")(bold(r)_1, ..., bold(r)_m)
$

Quello generato dalle colonne di $bold(A)$:

$
  C(bold(A)) = op("span")(bold(c)_1, ..., bold(c)_n)
$

= Sistemi lineari e sottospazi

L'insieme delle soluzioni del sistema lineare omogeneo
$bold(A) bold(x) = bold(0)$ è un sottospazio di $bb(R)^n$. Questa proprietà è
anche invertibile (ogni sottospazio di $bb(R)^n$ può essere interpretato come
l'insieme delle soluzioni di un sistema lineare omogeneo).

== Procedura per passare da un sottospazio ad un sistema omogeneo

Dato l'insieme ${bold(v)_1, ..., bold(v)_k}$ di vettori di $bb(R)^n$, bisogna
trovare un sistema lineare omogeneo le cui soluzioni siano i vettori
$bold(x) in op("span")(bold(v)_1, ..., bold(v)_k)$.

Detta $bold(A) = mat(delim: "[", bold(v)_1, dots.h, bold(v)_k)$ la matrice che
ha i vettori come colonne, il sistema cercato deve soddisfare la seguente
condizione:

$
  op("rg")(bold(A)) = op("rg")(bold(A) mid(|) bold(x))
$

*Esempio*:

Date 2 ennuple $bold(v)_1 = (-1, 1, 0, -3)$ e $bold(v)_2 = (1, -1, 2, 1)$,
troviamo il sistema lineare omogeneo le cui soluzioni sono lo spazio
$op("span")(bold(v)_1, bold(v)_2) subset bb(R)^4$.

$
  (bold(A) mid(|) bold(x)) = mat(
    delim: "[",
    -1, 1, x_1;
    1, -1, x_2;
    0, 2, x_3;
    -3, 1, x_4;
  )
$

Riduciamo $(bold(A) mid(|) bold(x))$ a scalini:

$
  (bold(A) mid(|) bold(x)) = mat(
    delim: "[",
    -1, 1, x_1;
    0, -2, -3 x_1 + x_4;
    0, 0, -3 x_1 + x_3 + x_4;
    0, 0, x_1 + x_2;
  )
$

Il sistema lineare che rende
$op("rg")(bold(A)) = op("rg")(bold(A) mid(|) bold(x))$ è:

$
  cases(
    -3 x_1 + x_3 + x_4 = 0,
    x_1 + x_2 = 0,
  )
$

= Polinomi come spazi vettoriali

$bb(R)[x]$ è lo spazio dei polinomi a coefficienti reali. Si definisce:

$
  bb(R)[x] = {sum_(i = 0)^delta a_i x^i " con " delta in bb(N) " e " a_delta != 0} union {bold(0)}
$

$delta$ è il grado del polinomio (per il polinomio nullo il grado non è
definito).

$bb(R)[x]$ non è finitamente generato: dato un insieme finito
$p_1(x), ..., p_(k)(x)$ con massimo grado $M$, il polinomio $x^(M + 1)$ ha grado
maggiore di $M$ e non appartiene a $op("span")(p_1(x), ..., p_(k)(x))$.

$bb(R)_(d)[x]$ è lo spazio dei polinomi di grado massimo $d$. Esso è finitamente
generato; un sistema di generatori è ${1, x, x^2, ..., x^d}$.

= Altri esempi e controesempi di sottospazi vettoriali

Dato lo spazio vettoriale $V = bb(M)_2(bb(R))$:

- Il sottoinsieme delle matrici a traccia nulla (la somma degli elementi sulla
  diagonale principale è $0$) è un sottospazio di $V$:

  $
    U = {mat(delim: "[", a_(1, 1), a_(1, 2); a_(2, 1), a_(2, 2)) in V mid(|) a_(1, 1) + a_(2, 2) = 0}
  $

- Il sottoinsieme delle matrici invertibili
  $U = {bold(A) mid(|) exists bold(A)^(-1)}$ non è un sottospazio. La matrice
  nulla $bold(0)$ non è invertibile perché $op("rg")(bold(0)) != n$.

Dato $V = bb(R)[x]$:

- Il sottoinsieme $U = {p(x) mid(|) p(1) = 0}$ è un sottospazio.
- Il sottoinsieme $U = {p(x) mid(|) " il grado di " p(x) " è d"}$ non è un
  sottospazio perché non contiene l'elemento nullo.

= Dipendenza e indipendenza lineare

- L'insieme ${bold(v)_1, ..., bold(v)_k}$ è *linearmente dipendente* se esistono
  $lambda_1, ..., lambda_k$ coefficienti non tutti nulli, tali che:

  $
    sum_(i = 1)^k lambda_i bold(v)_i = bold(0)
  $

- L'insieme ${bold(v)_1, ..., bold(v)_k}$ è *linearmente indipendente* quando:

$
  sum_(i = 1)^k lambda_i bold(v)_i = bold(0) <=> lambda_1 = ... = lambda_k = 0
$

Se ${bold(v)_1, ..., bold(v)_k}$ è linearmente dipendente e se $k >= 2$, allora
almeno uno dei vettori dell'insieme può essere scritto come combinazione lineare
degli altri elementi.

$
  lambda_1 bold(v)_1 + lambda_2 bold(v)_2 + lambda_3 bold(v)_3 = bold(0) " con " lambda_3 != 0 <=> bold(v)_3 = -lambda_1 / lambda_3 bold(v)_1 - lambda_2 / lambda_3 bold(v)_2
$

== Dipendenza e indipendenza lineare con le ennuple

Dato un insieme $S = {bold(v)_1, ..., bold(v)_k} subset.eq bb(R)^n$, la matrice
$bold(A) = mat(delim: "[", bold(v)_1, dots.h, bold(v)_k)$ e
$bold(lambda) = vec(delim: "[", lambda_1, dots.v, lambda_k)$:

- $S$ è linearmente indipendente quando $op("rg")(bold(A)) = k$, cioè quando il
  sistema $bold(A) bold(lambda) = bold(0)$ ha come unica soluzione
  $bold(lambda) = bold(0)$.
- $S$ è linearmente dipendente quando il sistema
  $bold(A) bold(lambda) = bold(0)$ ha soluzioni non nulle.

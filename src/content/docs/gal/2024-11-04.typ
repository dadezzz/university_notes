#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Definizione ed esistenza delle basi, estrazione di una base da un sistema di generatori, dimensione di uno spazio vettoriale e completamento a una base.",
  lang: "it",
  title: "Basi vettoriali: dimensione e completamento",
))

= Basi di spazi vettoriali

Dato uno spazio vettoriale $V$ finitamente generato, un insieme di vettori
$cal(B) = {bold(b)_1, ..., bold(b)_n}$ è una base di $V$ se è un sistema di
generatori ed è linearmente indipendente.

Sia $V$ uno spazio vettoriale finitamente generato con $V != {bold(0)}$; allora
$V$ ammette almeno una base.

*Esempi*:

- $bb(R)^4$:
  $cal(B) = {(1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1)}$
- $bb(M)_(2, 2)(bb(R))$:
  $cal(B) = {mat(delim: "[", 1, 0; 0, 0), mat(delim: "[", 0, 1; 0, 0), mat(delim: "[", 0, 0; 1, 0), mat(delim: "[", 0, 0; 0, 1)}$
- $bb(R)_(d)[x]$: $cal(B) = {1, x, ..., x^d}$

== Estrazione di una base da un sistema di generatori

Dato un insieme ${bold(v)_1, ..., bold(v)_k} subset bb(R)^n$ di generatori (con
$k >= n$):

+ Formiamo la matrice $n times k$:

  $
    bold(A) = mat(delim: "[", bold(v)_1, dots.h, bold(v)_k)
  $

+ Riduciamo $bold(A)$ a scalini.
+ I vettori corrispondenti alle colonne contenenti i pivot formano una base di
  $bb(R)^n$.

= Dimensione di uno spazio vettoriale

Siano $V$ uno spazio vettoriale, $cal(B) = {bold(b)_1, ..., bold(b)_n}$ una sua
base e $A = {bold(v)_1, ..., bold(v)_m}$ un insieme linearmente indipendente con
$m < n$; allora esiste una base di $V$ formata da $A$ e da altri $n - m$
elementi di $cal(B)$.

In particolare, ogni base di $V$ ha lo stesso numero di elementi: $n$. Questo
numero è detto dimensione di $V$ e si denota con:

$
  dim(V)
$

Se $V = {bold(0)}$, allora $dim(V) = 0$.

*Dimensioni di spazi vettoriali comuni*:

#table(
  columns: 2,
  table.header([*$V$*], [*$dim(V)$*]),
  [$bb(R)^n$], [$n$],
  [$bb(M)_(m, n)(bb(R))$], [$m n$],
  [$bb(R)_(d)[x]$], [$d + 1$],
)

= Completare un insieme linearmente indipendente a una base

Siano dati un insieme linearmente indipendente
$A = {bold(v)_1, ..., bold(v)_m} subset bb(R)^n$ e una base
$cal(B) = {bold(b)_1, ..., bold(b)_n} subset bb(R)^n$.

+ Formiamo la matrice:

  $
    bold(C) = mat(delim: "[", bold(A), bold(B))
  $

  dove $bold(A)$ ha come colonne i vettori di $A$ e $bold(B)$ ha come colonne i
  vettori di $cal(B)$.

+ Riduciamo $bold(C)$ a scalini.
+ Otteniamo $m$ pivot sulle prime $m$ colonne e la posizione degli altri $n - m$
  pivot in $bold(B)$ individua gli $n - m$ elementi di $cal(B)$ da aggiungere ad
  $A$ per ottenere una base di $bb(R)^n$.

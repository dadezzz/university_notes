#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Matrice a scalini, pivot e algoritmo di Gauss; rango, riduzione per righe e teorema di Rouché-Capelli con le condizioni di compatibilità di un sistema lineare.",
  lang: "it",
  title: "Matrici a scalini: pivot, rango e Rouché-Capelli",
))

= Matrice a scalini

Una matrice $bold(A)$ è detta a scalini se $forall bold(r)_i, bold(r)_(i + 1)$
(coppia di righe successive) si verifica una delle seguenti condizioni:

- $bold(r)_i$ e $bold(r)_(i + 1)$ sono non nulle e il numero di coefficienti
  nulli che precedono il primo coefficiente non nullo in $bold(r)_i$ è inferiore
  rispetto a quello in $bold(r)_(i + 1)$.
- $bold(r)_(i + 1)$ è nulla (tutti i coefficienti hanno valore $0$).

Il primo coefficiente non nullo delle righe non nulle di una matrice a scalini è
detto *pivot*.

Esempio di matrice a scalini:

$
  bold(A) = mat(
    delim: "[",
    p_1, *, *, *;
    0, p_2, *, *;
    0, 0, 0, p_3;
    0, 0, 0, 0;
  )
$

- $p_1$, $p_2$ e $p_3$ sono i pivot della matrice $bold(A)$.
- $*$ indica un coefficiente con valore qualsiasi.

== Algoritmo di Gauss

Questo algoritmo si usa per ridurre una matrice qualsiasi nella sua forma a
scalini. Da una matrice qualsiasi si possono ottenere diverse forme a scalini,
però *tutte avranno lo stesso numero di pivot*.

+ Cerchiamo la prima colonna che contiene un coefficiente non nullo e chiamiamo
  tale coefficiente $p_1$.
+ Scambiamo le righe in modo che la riga contenente $p_1$ diventi la prima.
+ Applichiamo operazioni elementari del tipo $E_(i, 1)(lambda)$ in modo da
  rendere $0$ tutti gli altri coefficienti della colonna di $p_1$.
+ Ripetiamo il procedimento con la matrice ottenuta escludendo la prima riga.

#starlight.note([
  Quando la matrice contiene dei parametri, è meglio collocare le righe che li
  contengono in fondo alla matrice.
])

== Rango di una matrice

Il rango di una matrice $bold(A)$ è il numero di pivot di una sua forma a
scalini. Si denota con: $op("rg")(bold(A))$.

= Riduzione per righe

La forma ridotta per righe di una matrice $bold(A)$ si denota con
$op("rref")(bold(A))$.

Si ottiene quando $bold(A)$ è ridotta a scalini e ogni suo pivot ha valore 1 ed
è l'unico elemento non nullo della sua colonna. Ogni matrice ammette un'unica
forma a scalini ridotta per righe.

Esempio di una matrice ridotta per righe:

$
  bold(A) = mat(
    delim: "[",
    1, 0, 0, 2;
    0, 1, 0, 0;
    0, 0, 1, 5;
  )
$

== Algoritmo della riduzione all'indietro

Si usa per passare da una matrice a scalini alla sua forma ridotta per righe.

+ Per ogni pivot $p_k$, eseguiamo l'operazione $D_(k)(p_k^(-1))$, in modo da
  portare il pivot ad avere valore 1.
+ Riduciamo a 0 tutti gli altri coefficienti della colonna di $p_k$ tramite
  operazioni di tipo $E_(j, k)(lambda)$.

= Teorema di Rouché-Capelli

Dato un sistema lineare in $n$ incognite, con la sua matrice completa associata
($bold(A) mid(|) bold(b)$), tale sistema è compatibile se e solo se:

$
  op("rg")(bold(A)) = op("rg")(bold(A) mid(|) bold(b))
$

In questo caso il sistema avrà:

- un'unica soluzione se $op("rg")(bold(A)) = n$;
- infinite soluzioni se $op("rg")(bold(A)) < n$;

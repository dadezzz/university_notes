#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Manipolazioni di tempo, forma e ampiezza dei segnali, con statistiche di valore medio, varianza, energia, potenza, cross-correlazione e autocorrelazione",
  lang: "it",
  title: "Trasformazioni dei segnali e relative statistiche",
))

= Manipolazione dei segnali

== Traslazione temporale

Introduzione di un anticipo o un ritardo del segnale agendo sull'asse temporale.

#image(
  "images/trasformazione-traslazione-temporale.png",
  alt: "Blocco traslazione temporale",
)

- $Delta t > 0$: introduco un ritardo;
- $Delta t < 0$: introduco un anticipo;

== Riscalamento temporale

Introduzione di una compressione o espansione del segnale agendo sull'asse
temporale.

#image(
  "images/trasformazione-riscalamento-temporale.png",
  alt: "Blocco riscalamento temporale",
)

- $0 < k < 1$: espando il segnale;
- $k > 1$: comprimo il segnale;

Se $k$ diventa negativo, allora il segnale viene anche invertito.

== Fattore di guadagno

Amplificazione o attenuazione agendo sull'ampiezza del segnale.

#image(
  "images/trasformazione-fattore-di-guadagno.png",
  alt: "Blocco fattore di guadagno",
)

- $g > 1$: amplifico il segnale;
- $0 < g < 1$: attenuo il segnale;

Se $g$ diventa negativo, il segnale viene ribaltato.

== Integrazione e derivazione

Dato che i segnali sono descrivibili come funzioni, possiamo integrarli e
derivarli:

#image(
  "images/trasformazione-integrale-derivata.png",
  alt: "Blocchi derivata e integrale",
)

Per le funzioni generalizzate:

- l'integrale di un impulso è un gradino e derivando un gradino si ottiene un
  impulso;
- derivando un impulso si ottiene un doppietto, ovvero una coppia di impulsi,
  uno positivo e uno negativo, centrati nell'origine;

#starlight.note([
  Il doppietto è definito come:

  $
    integral_(-oo)^(+oo) delta'(t) f(t) dif t = - integral_(-oo)^(+oo) delta(t) f'(t) dif t = - f'(0)
  $
])

= Statistiche dei segnali

Solitamente si usa la statistica su segnali di natura aleatoria; tuttavia, è
possibile calcolare alcuni valori interessanti anche per segnali deterministici.

== Valore medio

Il valore medio di un segnale deterministico in un dato intervallo temporale
$[t_1, t_2]$ è dato da:

$
  chevron.l x(t) chevron.r_[t_1, t_2] = 1 / (t_2 - t_1) integral_(t_1)^(t_2) x(t) dif t
$

o su tutto il dominio:

$
  overline(x) = chevron.l x(t) chevron.r = lim_(T -> oo) 1 / T integral_(- T / 2)^(T / 2) x(t) dif t
$

Tipicamente, un valore medio diverso da $0$ indica che è presente un offset
costante nel segnale. In questo caso viene sottratto per ottenere solamente le
variazioni.

== Valore quadratico medio e varianza

Il valore quadratico medio è definito:

$
  overline(x^2) = chevron.l x(t)^2 chevron.r = lim_(T -> oo) 1 / T integral_(- T / 2)^(T / 2) (x(t))^2 dif t
$

da cui possiamo ricavare la varianza:

$
  sigma_x^2 = overline(x^2) - overline(x)^2 = lim_(T -> oo) 1 / T integral_(- T / 2)^(T / 2) (x(t) - overline(x))^2 dif t
$

Una varianza elevata indica variazioni significative nel segnale, tipicamente
associate ad un più elevato contenuto informativo.

== Energia di un segnale

L'energia di un segnale è definita come:

$
  E_x = integral_(-oo)^(+oo) (x(t))^2 dif t
$

#starlight.caution([
  Per i segnali periodici non ha senso calcolarla, dato che $E_x$ assume un
  valore infinito.
])

I segnali per cui $E_x$ ha valore finito sono detti *segnali di energia*.

== Potenza di un segnale

La potenza $P_x$ di un segnale è la misura della sua energia sul tempo. La
formula coincide con quella del valore quadratico medio.

La potenza di un segnale di energia è sempre nulla; i segnali per cui $P_x$ non
è nulla sono detti *segnali di potenza*.

Un segnale può essere o di energia o di potenza, mai entrambi (in generale
esistono anche segnali che non sono né l'uno né l'altro, ad esempio un segnale
che cresce senza limiti nel tempo).

== Cross-correlazione

La cross-correlazione è utile per capire quanto due segnali siano simili tra
loro.

Dobbiamo distinguere tra segnali di energia e di potenza:

- per due segnali di energia $x(t)$ e $y(t)$:

  $
    cal(R)_(x, y)(tau) = integral_(-oo)^(+oo) x(t) y(t + tau) dif t
  $

- per due segnali di potenza $x(t)$ e $y(t)$ (su un intervallo lungo $T$):

  $
    cal(R)_(x, y)(tau) = lim_(T -> oo) 1 / T integral_(- T / 2)^(T / 2) x(t) y(t + tau) dif t
  $

In entrambi i casi lascio $x$ fermo e faccio scorrere $y$ di una quantità $tau$.

Si usa per verificare la somiglianza perché se i segnali sono allineati, il
valore dell'integrale sarà alto e positivo (i picchi e le valli hanno lo stesso
segno, quindi la moltiplicazione dà sempre valori positivi).

*Autocorrelazione*: si usa per misurare quanto un segnale è simile a se stesso
in altri istanti. Il valore a $tau = 0$ è il massimo (corrisponde alla potenza o
energia del segnale) e decade man mano che $abs(tau)$ aumenta.

Si dice che un segnale ha meno 'memoria' quando la sua autocorrelazione decade
più rapidamente man mano che ci si allontana da $tau = 0$.

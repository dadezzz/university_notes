#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Criteri per le posizioni reciproche di rette e piani nello spazio: parallelismo, incidenza, rette sghembe, ortogonalità e piano per due rette complanari.",
  lang: "it",
  title: "Rette e piani nello spazio: posizioni reciproche",
))

= Posizione reciproca nello spazio

== Tra due rette

Due rette distinte $r_1$ e $r_2$, individuate rispettivamente da un punto e un
vettore direzionale ($P$, $bold(v)$ e $Q$, $bold(w)$), possono essere:

- parallele se $bold(v) = lambda bold(w)$;
- incidenti se hanno un punto in comune;
- sghembe se non sono né parallele né incidenti.

$r_1$ e $r_2$ sono ortogonali se non sono parallele e se
$bold(v) dot bold(w) = 0$.

#starlight.note([
  Anche due rette sghembe possono essere ortogonali: basta che i loro vettori
  direzionali siano ortogonali, poiché un vettore equivalente a $bold(w)$ può
  essere applicato nello stesso punto di $bold(v)$.
])

== Rette complanari

Due rette parallele o incidenti giacciono sullo stesso piano. Per trovare il
piano $pi$ che le contiene:

- Se $r_1$ e $r_2$ sono incidenti, si possono ottenere equazioni parametriche di
  $pi$ usando le coordinate del punto di intersezione $P_0$ e dei vettori
  direzionali $bold(v)_1$ e $bold(v)_2$:

  $
    cases(
      x = x_P_0 + t v_1_1 + s v_2_1,
      y = y_P_0 + t v_1_2 + s v_2_2,
      z = z_P_0 + t v_1_3 + s v_2_3,
    )
  $

- Se sono parallele, si considera il fascio di piani avente sostegno $r_1$: ce
  n'è uno che contiene $r_2$. Si prende l'equazione del fascio e si impone il
  passaggio per un punto di $r_2$ non appartenente a $r_1$.

== Tra due piani

Dati $pi_1: n_1_1 x + n_1_2 y + n_1_3 z + d_1 = 0$ e
$pi_2: n_2_1 x + n_2_2 y + n_2_3 z + d_2 = 0$, essi possono essere:

- paralleli (o coincidenti) se $bold(n)_1 = lambda bold(n)_2$;
- incidenti altrimenti (la loro intersezione è una retta).

$pi_1$ e $pi_2$ sono ortogonali se $bold(n)_1 dot bold(n)_2 = 0$.

== Tra una retta e un piano

Dati un piano $pi$ con vettore normale $bold(n)$ e una retta $r$ con vettore
direzionale $bold(v)$, essi possono essere:

- paralleli se $bold(n) dot bold(v) = 0$; in questo caso la retta è parallela al
  piano oppure giace su di esso;
- incidenti se $bold(n) dot bold(v) != 0$, cioè se si intersecano in un solo
  punto.

$r$ e $pi$ sono ortogonali se $bold(v) = lambda bold(n)$.

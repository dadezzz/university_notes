#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Retroazione a catena aperta e chiusa, dropout nei regolatori LDO e regolatori switching step-up e step-down: induttore, diodo Schottky e convertitori sincroni.",
  lang: "it",
  title: "Sistemi retroazionati, LDO e regolatori switching",
))

= Sistemi retroazionati

In alcuni componenti l'uscita è collegata a un altro piedino d'ingresso dello
stesso circuito, in modo che il sistema possa confrontare il valore uscente con
quello desiderato e correggere l'azione.

Si può quindi distinguere tra due tipi di sistemi:

- *Open loop*: si agisce senza controllare il risultato; ad esempio si sa di
  aver accelerato, ma non si sa di quanto.
- *Closed loop*: l'uscita viene riportata all'ingresso; ad esempio si accelera
  fino a raggiungere i $50 thick upright("km" #h(-1pt) \/ #h(-1pt) h)$.

= Dropout e regolatori LDO

Un parametro caratteristico dei regolatori di tensione è il dropout, ovvero la
differenza di tensione minima tra ingresso e uscita necessaria per far
funzionare il componente.

I regolatori LDO (Low Dropout) funzionano con dropout molto piccoli, dell'ordine
di $0.3 thick upright(V)$ o $0.5 thick upright(V)$.

= Regolatori switching

I regolatori switching usano componenti in grado di immagazzinare energia e
trasferirla tramite commutazione, anziché dissipare la tensione in eccesso. La
corrente scorre solo per una frazione di ogni periodo di commutazione, detta
duty cycle; l'onda quadra risultante viene poi filtrata fino a ottenere una
tensione continua pari al valore medio.

I componenti essenziali sono:

- un commutatore (transistor), pilotato da una logica a tempo;
- un induttore, che si oppone alle variazioni di corrente;
- un diodo, che chiude il circuito nella fase di scarica e previene le
  sovratensioni;
- un condensatore, che livella la tensione.

== Funzionamento

#include "frames/step-down.typ"

+ Quando si chiude il transistor, la corrente inizia a scorrere dall'ingresso
  attraverso l'induttore, che si oppone alle variazioni di corrente e
  immagazzina energia nel proprio campo magnetico.
+ Quando il transistor si apre, l'induttore tende a mantenere costante la
  corrente: si genera una sovratensione che polarizza direttamente il diodo, il
  quale chiude il circuito e permette alla corrente di continuare a scorrere.
+ Il condensatore d'uscita si carica con l'energia trasferita dall'induttore e
  la restituisce al carico, livellando la tensione d'uscita.

La logica interna può leggere il valore d'uscita e variare il duty cycle (o la
frequenza di switching) per regolare la tensione.

Le inefficienze di questo tipo di circuito sono date da:

- resistenza in serie dell'induttore: la bobina è un filo di rame con resistenza
  non nulla;
- resistenza del transistor quando è in conduzione;
- caduta di tensione del diodo: un diodo classico ha circa
  $0.7 thick upright(V)$ di caduta, mentre uno Schottky ne ha circa
  $0.3 thick upright(V)$.

Nei convertitori sincroni il diodo è sostituito con un secondo MOSFET, comandato
in maniera complementare rispetto al primo, eliminando così la caduta di
tensione e aumentando l'efficienza.

== Step-up switching

#include "frames/step-up.typ"

Negli step-up il principio di commutazione è lo stesso, ma il diodo è disposto
diversamente: l'induttore è collegato direttamente all'ingresso e la sua energia
viene trasferita al condensatore d'uscita, aumentando così la tensione
($V = Q / C$: spostando cariche sul condensatore si aumenta la tensione).

Quando il transistor si apre, l'induttore, che si oppone alla diminuzione della
corrente, continua a spingere l'energia verso l'uscita e la sua tensione si
somma a quella d'ingresso, creando così un effetto "pompa".

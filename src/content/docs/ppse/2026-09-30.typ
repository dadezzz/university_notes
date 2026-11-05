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

I regolatori LDO (Low Dropout) funzionano con dropout molto piccoli
($0.3 thick upright(V)$ o $0.5 thick upright(V)$).

= Regolatori switching

I regolatori switching usano componenti in grado di immagazzinare energia e
trasferirla tramite commutazione, anziché dissipare la tensione in eccesso. La
corrente scorre solo per una frazione di ogni periodo di commutazione (duty
cycle); l'onda quadra risultante viene poi filtrata fino a ottenere una tensione
continua pari al valore medio.

I componenti essenziali sono:

- un commutatore (transistor), pilotato da una logica a tempo;
- un induttore, che si oppone alle variazioni di corrente;
- un diodo, che chiude il circuito nella fase di scarica e previene le
  sovratensioni;
- un condensatore, che livella la tensione;

Quando il transistor entra in conduzione, l'induttore si carica di corrente e
accumula energia. All'apertura del transistor la corrente prosegue verso il
diodo, scaricando l'energia sul condensatore in uscita.

La logica interna può leggere il valore d'uscita e variare il duty cycle (o la
frequenza di switching) per regolare la tensione.

Le inefficienze di questo tipo di circuito sono date da:

- resistenza in serie dell'induttore: la bobina è un filo di rame con resistenza
  non nulla;
- resistenze del transistor quando è in conduzione;
- caduta di tensione del diodo: un diodo classico ha circa
  $0.7 thick upright(V)$ di caduta, mentre uno Schottky ne ha circa
  $0.3 thick upright(V)$;

Nei convertitori sincroni il diodo è sostituito con un secondo MOSFET, comandato
in maniera duale al primo, eliminando così la caduta di tensione.

== Step-up switching

Negli step-up la commutazione è la stessa, ma il diodo è posizionato in maniera
diversa, in modo da spingere l'energia dell'induttore sul condensatore e far
aumentare la tensione ($V = Q / C$, quindi spostando cariche sul condensatore si
aumenta la tensione).

Una volta che l'induttore arriva a regime e si apre il transistor, l'induttore
continua a spingere (perché si oppone alla diminuzione della corrente) e la sua
tensione si somma a quella di ingresso, creando così un effetto "pompa".

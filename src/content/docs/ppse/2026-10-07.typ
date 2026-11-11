#import "../_templates/starlight.typ" as starlight;

#show: starlight.setup

#metadata((
  description: "Classificazione termica dei componenti, sensori NTC e PTC, alimentazioni multiple con diodi e regolatore step-down TPS5410, con analisi di ripple, spike ed EMC.",
  lang: "it",
  title: "Sensori di temperatura e regolatore TPS5410",
))

= Classificazione termica dei componenti

I componenti elettronici si classificano per intervallo di temperatura di
esercizio, garantito dal produttore. Solitamente si trovano tre categorie:

- commerciale: da 0 °C a 80 °C;
- professionale/esteso: da -20 °C a 100 °C;
- militare/automotive: da -40 °C a 150 °C.

= Sensori di temperatura

Un sensore di temperatura non può essere scelto a caso. In base al modello si
può misurare un intervallo diverso di temperatura; se si va fuori da questo
intervallo, i valori riportati potrebbero non riflettere la realtà.

Alcuni tipi di sensori di temperatura sono:

- *NTC (Negative Temperature Coefficient)*: la loro resistenza diminuisce
  all'aumentare della temperatura. La variazione è esponenziale, quindi la
  sensibilità è massima in un certo intervallo e si appiattisce agli estremi.
- *PTC (Positive Temperature Coefficient)*: la resistenza aumenta all'aumentare
  della temperatura.

= Alimentazioni multiple

In fase di progetto si possono prevedere fonti di alimentazione diverse, per
garantire l'utilizzo in un maggior numero di situazioni o per affiancare una
sorgente poco potente con un'altra.

È importante considerare il caso in cui entrambe le fonti sono collegate. Se una
sorgente avesse un potenziale più alto dell'altra, la corrente verrebbe "spinta"
verso la seconda. Per risolvere, di solito si usano diodi per impedire alla
corrente di scorrere nel verso non voluto.

#starlight.caution([
  Quella con i diodi non è la soluzione migliore, dato che questi si comportano
  come resistenze che assorbono potenza e producono calore.

  Vedremo che usare un MOSFET di tipo P come interruttore sarà più efficiente.
])

= Step-down TPS5410

Il TPS5410 è un regolatore step-down di tipo switching, molto usato e
affidabile. Le caratteristiche principali sono:

- tensione di ingresso da $5.5 thick upright(V)$ a $36 thick upright(V)$;
- corrente di uscita massima $1 thick upright(A)$;
- efficienza fino al 95 %;
- frequenza di commutazione di $500 thick upright(k "Hz")$;
- resistenza interna in serie di $110 thick upright(m Omega)$.

Il regolatore ha un pin di *enable*. Lasciandolo flottante, un generatore di
corrente interno lo porta a livello alto e il componente si accende. Portandolo
a massa si spegne.

Il funzionamento si basa su un controllo a retroazione: la tensione di uscita
viene partizionata e confrontata con un riferimento interno (preciso) di
$1.221 thick upright(V)$.

Altre funzionalità sono:

- soft start: all'accensione il condensatore è scarico, quindi la tensione sale
  gradualmente;
- protezione termica: se il componente si surriscalda, si ferma e poi riparte da
  solo una volta raffreddato;
- protezione da sovracorrente: la resistenza del MOSFET è usata anche per
  rilevare cortocircuiti.

== EMC, ripple e spike

Osservando i diagrammi nel datasheet del componente, si nota che la tensione di
uscita non è costante, ma presenta piccoli disturbi residui del processo di
switching. Si distingue tra:

- *ripple*: ondulazione introdotta dallo switching;
- *spike*: disturbi sul fronte di salita e di discesa, legati alla derivata del
  segnale.

Per aumentare la compatibilità elettromagnetica (EMC), in modo da non disturbare
i componenti vicini, è necessario aggiungere condensatori in parallelo per
smorzare le variazioni rapide.

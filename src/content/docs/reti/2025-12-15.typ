#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Algoritmi distance vector e Bellman-Ford, problema del count to infinity con split horizon e poisoned reverse; funzionamento di RIP e BGP, messaggi e RIB.",
  lang: "it",
  title: "Distance vector, algoritmo RIP e protocollo BGP",
))

= Distance vector

Gli algoritmi di routing con distance vector sono algoritmi distribuiti che non
richiedono conoscenza della topologia di rete.

Le uniche informazioni che un router deve sapere sono i propri vicini e il costo
dei link verso di essi.

== Algoritmo di Bellman-Ford

Dati:

- `N_x`: insieme di router vicini di `x`;
- `R_x`: tabella di inoltro di `x`;
  - `R_x[d]`: riga della tabella di inoltro per la destinazione `d`;
    - `R_x[d].cost`: costo per raggiungere `d`;
    - `R_x[d].nextHop`: vicino a cui inoltrare il pacchetto per raggiungere `d`;
    - `R_x[d].time`: usato per invalidare percorsi troppo vecchi;
- `D_x`: vettore con tutte le distanze (costi dei percorsi) di `x`:
  `D_x = { (d, R_x[d].cost) \mid d in R_x }`;

```
R_x[n].cost = c(x, n);
R_x[n].nextHop = n;
R_x[n].time = now();

ogni T secondi:
  invia D_x a tutti i router in N_x;

quando x riceve D_y da un vicino y:
  for (d, c) in D_y:
    if (d not in R_x || c + c(x, y) < R_x[d].cost || y == R_x[d].nextHop):
      R_x[d].cost = c + c(x, y);
      R_x[d].nextHop = y;
      R_x[d].time = now();
```

== Count to infinity

Il count to infinity è un problema che si manifesta nei protocolli a distance
vector.

*Esempio*:

+ Si consideri una rete con i nodi A, B e C collegati in serie.
+ B dice ad A che C è a distanza 1 da B, quindi A registra un costo pari a 2 per
  raggiungere C attraverso B.
+ Il link tra B e C fallisce.
+ A pensa che C sia ancora raggiungibile e dice a B che C è a distanza 2 da A,
  quindi B registra un costo pari a 3 per raggiungere C attraverso A.
+ B pensa che C sia raggiungibile attraverso A e gli risponde dicendo che ora C
  si trova a distanza 3 da B, quindi A aggiorna il proprio costo a 4.

Questo ciclo si ripete all'infinito.

=== Soluzioni

- impostare un numero massimo di hop per la propagazione dei distance vector;
- split horizon: quando un nodo manda aggiornamenti a un vicino, omette le rotte
  apprese da quel vicino;
- poisoned reverse: finché A raggiunge C attraverso B, A comunica che
  `D_A(C) = oo`;

= Routing information protocol

RIP è un protocollo di routing intra-AS che utilizza un algoritmo distance
vector.

Il suo vantaggio principale è la semplicità di gestione; gli svantaggi sono la
lentezza della convergenza e la limitata scalabilità a reti di grandi
dimensioni.

La metrica è il numero di hop, il cui valore massimo è 15. Un singolo hop non
può avere un costo maggiore di 1. Il protocollo usa un meccanismo di poisoned
reverse, dove 16 indica costo infinito.

Ogni 30 secondi, o quando cambiano le tabelle di routing, RIP invia i distance
vectors con dei messaggi detti *RIP advertisement*. I messaggi sono inviati
all'indirizzo multicast 224.0.0.9 sulla porta 520/UDP.

Ogni messaggio contiene un elenco di fino a 25 sottoreti di destinazione, con la
distanza del mittente rispetto a ciascuna di esse.

== Guasti sui nodi

Se un router non riceve notizie dal vicino per 180 secondi, lo considera guasto.
Il router modifica quindi la propria tabella e invia annunci agli altri vicini.

= BGP

BGP è il protocollo standard usato per collegare router appartenenti ad AS
diversi.

- gli AS comunicano tra loro per condividere informazioni di raggiungibilità;
- ogni AS può decidere autonomamente i propri punti di ingresso e uscita;
- ogni AS può decidere quali informazioni condividere e con quali vicini
  condividerle;

#starlight.note([
  Gli AS che forniscono transito verso altri AS sono detti *transit AS*.
])

Dato che le relazioni tra AS sono complesse, anche BGP deve esserlo, per
adattarsi a tutti i casi possibili.

Un AS:

- può decidere se pubblicizzare informazioni di raggiungibilità per le proprie
  reti interne;
- può decidere di ritrarre le informazioni in qualsiasi momento;
- può decidere di offrire o meno il transito verso altri AS;

== Messaggi BGP

I router BGP parlano tra loro attraverso una connessione TCP.

Dato che BGP è un path vector protocol, i router non condividono solo la
raggiungibilità di un certo prefisso, ma anche il percorso per raggiungerlo.

Le interconnessioni tra AS sono controllate da contratti. BGP implementa filtri
per controllare ciò che un router è abilitato a condividere con un vicino:

- filtri in ingresso: applicati alle rotte da applicare al proprio sistema;
- filtri in uscita: applicati alle rotte inviate dal proprio sistema;

Ogni router BGP condivide solamente il proprio best path per raggiungere una
destinazione. Non è detto che il best path sia il percorso più veloce, potrebbe
anche essere quello più conveniente per il gestore dell'AS.

BGP usa quattro tipi di messaggi:

=== Open

#table(
  columns: 2,
  table.header([*Sezione*], [*Lunghezza in bit*]),
  [version], [8],
  [my ASN], [16],
  [hold time], [16],
  [BGP id], [32],
  [optional parameters length], [8],
  [optional parameters], [ variabile],
)

Usato per aprire una nuova connessione BGP. Se viene accettato, la risposta sarà
un messaggio keepalive di conferma.

L'hold time determina il tempo massimo di inattività della sessione: se non si
ricevono messaggi entro questo intervallo, la sessione viene chiusa. Si usa il
minore tra i due valori proposti dai peer.

Il BGP id è l'indirizzo IP che identifica lo speaker.

=== Notification

#table(
  columns: 2,
  table.header([*Sezione*], [*Lunghezza in bit*]),
  [error code], [8],
  [error subcode], [8],
  [dati], [variabile],
)

Usato per notificare errori. Sono definiti 6 codici di errore e 20 sotto-codici.

=== Keepalive

Usato per mantenere attiva la connessione. Deve essere inviato a intervalli
inferiori all'hold time, tipicamente un terzo.

Possono essere disattivati impostando l'hold time a 0.

=== Update

Usato per inoltrare conoscenze ad altri nodi.

Le informazioni possono essere di due tipi:

- additive: annunciano nuovi percorsi;
- sottrattive: rimuovono percorsi per raggiungere una destinazione.

==== Withdraw

Un withdraw (ritiro) è l'azione di rimozione di una rotta. Si effettua un
withdraw quando non c'è più alcun percorso disponibile verso una certa
destinazione.

Un'operazione molto comune è quella di utilizzare un withdraw seguito da un
update per rimuovere una rotta non più valida e offrire al suo posto un percorso
alternativo.

Con l'implicit withdrawal (ritiro implicito), non è necessario annunciare
esplicitamente il ritiro prima di un update.

== RIB

BGP usa tre tabelle per le rotte:

- ADJ_RIB_IN:
  - contiene le rotte accettate in ingresso;
  - usato per valutare percorsi alternativi;
- routing table: contiene i best path correnti;
- ADJ_RIB_OUT: contiene le rotte che hanno superato i filtri in uscita e che
  possono essere condivise;

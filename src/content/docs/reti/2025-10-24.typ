#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "I protocolli ARQ per recuperare gli errori: Stop-and-Wait, pipelining con finestre di trasmissione e ricezione, Go-back-N con ACK cumulativi e Selective Repeat.",
  lang: "it",
  title: "Protocolli ARQ: Stop-and-Wait e Selective Repeat",
))

= Protocolli ARQ

I protocolli ARQ (Automatic Repeat reQuest) sono una classe di protocolli che
cerca di recuperare gli errori di trasmissione dei pacchetti.

Per notificare al trasmettitore una corretta trasmissione si usano speciali
pacchetti, comunemente detti ACK (acknowledgments).

I protocolli più rilevanti di questo tipo sono:

- Stop-and-Wait;
- Go-back-N;
- Selective Repeat;
- TCP;

== Stop-and-Wait

In questo protocollo, il trasmettitore invia una PDU, ma ne conserva anche una
copia locale con un timeout fissato. Poi attende la ricezione del rispettivo ACK
e, in sua mancanza, invia di nuovo il pacchetto quando scade il timeout.

Il ricevitore genera il checksum dei dati e controlla il numero di sequenza: se
non corrispondono a quelli inviati, il pacchetto viene scartato; altrimenti
invia l'ACK.

Alla ricezione dell'ACK vengono di nuovo controllati il checksum e il numero di
sequenza.

#starlight.img(
  "images/diagramma-ack-stop-and-wait.png",
  alt: "Diagramma del funzionamento di Stop-and-Wait",
)

Il protocollo è molto inefficiente perché, per ogni pacchetto inviato, bisogna
aspettare il doppio del ritardo di propagazione prima di poterne inviare un
altro (assumendo trascurabile il tempo di ricezione dell'ACK).

== Protocolli con pipelining

Il pipelining consiste nell'invio di più pacchetti prima che sia stato ricevuto
l'ACK dei precedenti.

Il pipelining aumenta l'efficienza del protocollo di un fattore pari alla
grandezza del buffer dei pacchetti inviati (anche detto *finestra*), perché si
riesce a limitare la perdita di tempo dovuta al round trip time tra
client-server (dati) e server-client (ACK).

#starlight.img(
  "images/diagramma-ack-go-back-n.png",
  alt: "Diagramma del funzionamento di Go-back-N",
)

Di seguito definiamo alcuni nomi che vengono usati in maniera standard:

- finestra di trasmissione ($W_T$): numero di PDU che il trasmettitore può
  inviare senza aver ricevuto l'ACK delle precedenti;
- finestra di ricezione ($W_R$): numero di PDU che il ricevitore può accettare
  prima di processarle;
- puntatore low ($W_"LOW"$): puntatore al primo pacchetto della finestra di
  trasmissione (quello inviato per primo in ordine cronologico);
- puntatore up ($W_"UP"$): puntatore all'ultimo pacchetto già trasmesso (che
  potrebbe non coincidere con l'ultimo pacchetto in $W_T$);

A seconda del protocollo usato, si possono usare diversi tipi di ACK:

- ACK individuale: indica la ricezione di un pacchetto specifico;
- ACK cumulativo: indica la ricezione fino ad un certo pacchetto;
- ACK negativo (NACK): indica un errore di trasmissione per un singolo
  pacchetto;
- piggybacking: inserimento di un ACK in un pacchetto di dati (utile se il
  server deve comunque inviare risposte);

=== Go-back-N

Go-back-N funziona con gli ACK cumulativi: quando il timer del pacchetto
$W_"LOW"$ scade, il trasmettitore rinvia tutti i pacchetti per cui non ha ancora
ricevuto un ACK.

=== Selective Repeat

Selective Repeat invece usa ACK individuali. Viene mantenuto un timer per ogni
pacchetto inviato e non ancora confermato, e allo scadere si rinvia solo il
pacchetto corrispondente.

In Selective Repeat, i numeri di sequenza hanno un andamento ciclico e le
dimensioni delle finestre di trasmissione e ricezione devono essere scelte in
modo da non creare ambiguità. In generale $W_T + W_R <= 2^k$, dove $2^k$ è la
dimensione dello spazio dei numeri di sequenza.

In pratica, se vengono consegnati correttamente tutti i pacchetti ma vengono
persi tutti gli ACK, le finestre $W_T$ e $W_R$ devono rimanere al più adiacenti,
senza mai sovrapporsi.

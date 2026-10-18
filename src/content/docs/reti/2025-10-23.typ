#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Socket come interfaccia verso il livello di trasporto, multiplexing e demultiplexing, porte TCP/UDP, formato e funzionamento del checksum del segmento UDP.",
  lang: "it",
  title: "Socket, livello di trasporto e protocollo UDP",
))

= Socket

La socket è l'interfaccia di programmazione usata dalle applicazioni per inviare
dati al livello di trasporto. Di solito separa anche l'userspace dal sistema
operativo.

#starlight.img(
  "images/socket-alto-livello.png",
  alt: "Vista ad alto livello del funzionamento di una socket",
)


Per effettuare un trasferimento di dati:

1. il server (host ricevente) deve aprire una socket e iniziare ad ascoltare;
2. il client (host trasmittente) inizia la connessione;
3. il server accetta la richiesta e può rispondere;

#starlight.img(
  "images/socket-esempio-richiesta.png",
  alt: "Esempio di richiesta con socket",
)


= Livello di trasporto

I protocolli del livello di trasporto si occupano della comunicazione logica tra
i processi su 2 host differenti.

L'host inviante divide i messaggi in segmenti e li passa al livello di rete,
mentre quello ricevente ricompone i messaggi e li passa al livello applicazione.

I principali protocolli usati sono 2:

- TCP: affidabile, garantisce la consegna ordinata dei byte;
- UDP: best effort;

Questo layer non offre alcuna garanzia sul ritardo e sulla larghezza di banda
della rete.

== Multiplexing/demultiplexing

Il trasmettitore effettua il multiplexing, ovvero raccoglie i dati di diverse
socket e aggiunge la PCI.

Il ricevitore invece effettua il demultiplexing, ovvero legge la PCI e indirizza
i dati ricevuti alle diverse socket in ascolto.

== Porte TCP e UDP

La destinazione finale di un segmento non è un host, ma un processo su
quell'host.

L'interfaccia tra l'applicazione e il livello di trasporto è la *porta*,
identificata da un numero a 16 bit.

Generalmente, le porte di sorgente e destinazione sono diverse:

- Solo la porta in ascolto sull'host ricevente deve essere conosciuta (e quindi
  di solito ha poche cifre); le risposte vengono inviate da quella stessa porta.
- Il trasmettitore invece può aprire più connessioni in parallelo, che devono
  partire da porte diverse: assegna quindi a ciascuna un numero casuale di più
  cifre, in modo da evitare conflitti.

= UDP

UDP è il servizio di trasporto più semplice. Ogni segmento può andare perso o
essere consegnato fuori sequenza.

I vantaggi sono:

- è un protocollo stateless (meno risorse richieste);
- non richiede di stabilire una connessione (meno ritardi);
- ha delle testate più piccole (meno dati trasmessi);

Un segmento UDP è composto da 4 sezioni di testata + i dati dell'applicazione.

#table(
  columns: 2,
  table.header([*Sezione*], [*Lunghezza in bit*]),
  [porta sorgente], [16],
  [porta destinazione], [16],
  [lunghezza segmento (incluso l'header)], [16],
  [checksum], [16],
  [dati applicazione], [?],
)


== Checksum UDP

Il protocollo UDP non offre alcuna garanzia sull'arrivo del segmento alla
destinazione, tantomeno che esso arrivi in maniera ordinata rispetto agli altri.

C'è però un meccanismo che permette di verificare che i bit all'interno del
singolo segmento non siano stati alterati.

Il mittente tratta il contenuto del segmento come una sequenza di interi a 16
bit. Esso somma questi interi e ne calcola il complemento a 1. Questo valore è
posto nel campo checksum della testata.

Il ricevente somma gli interi del contenuto al checksum. Il risultato dovrebbe
essere il numero `0b1111111111111111`.

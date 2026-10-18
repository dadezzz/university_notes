#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Commutazione di circuito e di pacchetto, store and forward, congestione, multiplexing statistico e struttura gerarchica di Internet con ISP, IXP, PoP e CDN.",
  lang: "it",
  title: "Commutazione, pacchetti e struttura di Internet",
))

= Commutazione di circuito

È stata la prima tecnologia utilizzata. Le risorse di rete sono suddivise in
porzioni. Ogni connessione riceve una di queste porzioni; anche se non trasmette
dati, occupa spazio sulla rete.

La divisione delle risorse può avvenire in 3 modi:

- ripartizione del bit rate;
- divisione delle frequenze: ogni utente comunica su una specifica frequenza; le
  trasmissioni possono avvenire in parallelo, ma è limitato il numero di utenti
  che possono condividere il canale;
- divisione del tempo: ogni utente riceve uno slot di tempo in cui trasmettere,
  poi tocca al successivo. Non ci sono limiti sul numero di utenti, ma
  ovviamente si abbassa la velocità per ciascuno.

= Commutazione di pacchetto

La commutazione di pacchetto è il principale metodo di trasmissione usato in
Internet. Il flusso di dati da un punto all'altro viene diviso in pacchetti.

Le risorse vengono utilizzate pienamente: se un utente non trasmette pacchetti,
allora gli altri avranno più spazio.

Gestione delle risorse contese:

- *store and forward*: chi inoltra un pacchetto deve riceverlo per intero prima
  di poterlo ritrasmettere verso il nodo successivo.

  Se il buffer di un router è pieno, allora i pacchetti vengono scartati.

- *congestione*: bisogna definire una strategia per quando un nodo riceve più
  pacchetti di quanti ne possa trasmettere.

Le risorse vengono suddivise in maniera best-effort (la suddivisione non è del
tutto equa).

*Multiplexing statistico*: la banda che ogni host ottiene non può essere
determinata con certezza. Dipende da molti fattori come il buffering sui
routers, la velocità dei collegamenti e gli eventuali colli di bottiglia sul
percorso...

= Struttura di Internet

Internet segue una struttura gerarchica, di solito determinata da chi fornisce
l'infrastruttura.

+ ISP (Internet Service Provider) di livello 1:
  - livello più alto, generalmente gestiscono la maggior parte del traffico
    nazionale/internazionale;
  - comunicano tra di loro come peer;
+ ISP di livello 2:
  - si connettono ad un numero ristretto di ISP di livello 1 e talvolta con
    altri di livello 2;
  - generalmente si collegano con altri ISP che sono geograficamente vicini;
+ ISP di livello 3: ISP ancora più piccoli e localizzati;

Altri tipi di nodi:

- IXP (Internet eXchange Point): zone dove diversi ISP collegano le loro reti,
  essenzialmente strutture piene di switch;
- PoP (Point of Presence): zone dove si concentrano routers che fanno peering
  con altri ISP;
- CDN (Content Delivery Network): alcuni cloud provider si collegano
  direttamente a grandi ISP perché occupano da soli una parte significativa
  della rete;

#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Definizione di protocollo e struttura di Internet: l'edge, l'accesso (dial-up, DSL, FTTH) e i mezzi trasmissivi come doppino, coassiale, fibra ottica e radio.",
  lang: "it",
  title: "Protocolli, edge della rete e mezzi trasmissivi",
))

= Protocollo

Un protocollo definisce il formato, l'ordine dei messaggi scambiati tra 2 entità
e talvolta le azioni intraprese in fase di trasmissione e/o ricezione di un
messaggio o di un altro evento.

= Zone della rete Internet

== Edge

È la zona ai confini della rete, dove si trovano gli utenti.

Tipi di collegamento ad Internet:

- dial-up:
  - viaggia sulla rete telefonica;
  - fino a 56 kbit/s;
  - non è possibile navigare e telefonare allo stesso momento;
- DSL (digital subscriber line):
  - fino a 1-5 Mbit/s in upstream;
  - fino a 10-50 Mbit/s in downstream;
- FTTH (fiber to the home);

=== Tecnologie di comunicazione

==== Doppino intrecciato

Tipicamente uno o più doppini intrecciati (2 fili di rame avvolti).

Talvolta i cavi sono schermati per prevenire interferenze:

- nessuna: unshielded;
- schermatura per doppino: shielded;
- lamina che avvolge il cavo: foiled;
- entrambi i metodi sopra: screened;
- nomenclatura cavi in formato X/YTP, dove:
  - X è la schermatura dell'intero cavo:
    - X=U: unshielded;
    - X=F: foiled;
    - X=S: maglia metallica intrecciata;
    - X=SF: entrambe;
  - Y è la schermatura di ogni doppino:
    - Y=U: unshielded;
    - Y=F: foiled;

Tipologie di cavo:

- cavo patch (straight-through): usato per collegare un host al router;
- cavo cross (crossover): usato per collegare 2 host tra loro; inverte i fili di
  entrata e uscita in modo che i computer non debbano essere configurati.

In realtà tutte le schede di rete moderne supportano una configurazione
automatica, quindi il tipo di cavo usato non ha più molta importanza.

==== Cavo coassiale

2 conduttori in rame concentrici.

Era il metodo più usato su grandi distanze prima dell'introduzione della fibra
ottica.

==== Fibra ottica

Molto più sottile e flessibile del cavo coassiale.

Consente elevate velocità di trasmissione. Molti cavi possono essere messi
vicini poiché non interferiscono tra loro. Inoltre si riducono gli errori di
trasmissione.

==== Canali radio

- WiFi:
  - usato per reti LAN;
- 3G/4G/5G:
  - usato per reti WAN;
- reti satellitari:
  - GEO: orbita alta, basso numero di satelliti dato che copre una grande area
    ma elevati ritardi di trasmissione (0.5 secondi);
  - LEO (tipo Starlink): orbita bassa, richiede un grande numero di satelliti ma
    offre migliori prestazioni;

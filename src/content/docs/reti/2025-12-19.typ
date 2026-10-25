#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Servizi del livello di collegamento, rilevamento errori con parity bit e CRC, link punto-punto e broadcast, protocolli MAC: ALOHA, CSMA, TDMA, FDMA e CDMA.",
  lang: "it",
  next: false,
  title: "Livello di collegamento: errori e protocolli MAC",
))

= Livello di collegamento

Al livello di collegamento i *frame* viaggiano tra host, detti *nodi*,
attraverso *link*. Un percorso può contenere link di diversi tipi.

Al livello 2 i frame viaggiano solo tra host direttamente collegati da un
canale. Ogni nodo è identificato da un indirizzo MAC.

== Servizi offerti

- Controllo di flusso: la velocità di trasmissione è adattata alle possibilità
  di trasmettitore e ricevitore.
- Rilevamento di errori: dove la comunicazione è ritenuta poco affidabile,
  alcuni protocolli offrono funzionalità di controllo degli errori.
- Correzione di errori: il ricevitore è in grado di identificare e correggere
  errori sui bit senza richiedere ritrasmissioni.
- Half-duplex e full-duplex: in un collegamento half-duplex i nodi possono
  trasmettere e ricevere solo alternativamente, mentre in un collegamento
  full-duplex possono farlo contemporaneamente.

= Rilevamento di errori

I bit EDC sono bit ridondanti utilizzati per rilevare e correggere gli errori.
In generale, maggiore è la ridondanza, maggiore è la protezione.

Il meccanismo a _parity bit_ introduce un solo bit in più che indica se il
numero di bit a 1 nel messaggio è pari o dispari.

La ridondanza si può implementare nel seguente modo:

- messaggio: `hello`;
- ridondanza: `hhh eee lll lll ooo`;
- interleaving: `hel loh ell ohe llo` (protegge da errori su più segmenti);
- errori: `hel loh exx xxx llo`;
- de-interleaving: `hhx eex lxl lxl oxo`;
- scelta a maggioranza: `hello`;

Il cyclic redundancy check (CRC) è un algoritmo più efficiente per il
rilevamento di errori.

- Considera i bit di dati come un numero binario $D$.
- Sceglie un numero $G$ di $r + 1$ bit, detto generatore, noto a priori al
  mittente e al ricevente.
- Si compone il CRC $R$ scegliendo $r$ bit in modo che il numero ottenuto
  concatenando $D$ e $R$ sia divisibile esattamente per $G$.
- Se il ricevente divide per $G$ il numero ottenuto concatenando $D$ e $R$ e il
  resto è diverso da 0, allora c'è un errore.

= Tipi di collegamento

- punto-punto: il collegamento avviene esclusivamente tra due interfacce di
  rete;
- broadcast: il mezzo di trasmissione è condiviso e necessita di un algoritmo di
  coordinamento per accordarsi ed evitare conflitti sulle trasmissioni;

== Protocollo MAC (Multiple Access Control)

Idealmente, quando un nodo trasmette su un link in grado di supportare $R$
bit/s, vorremmo che lo facesse a velocità $R$. Quando $M$ nodi trasmettono, la
velocità dovrebbe essere $R / M$ per ciascuno.

Il sistema di coordinazione deve essere completamente decentralizzato e non deve
richiedere clock sincronizzati.

Nel tempo sono state sviluppate tre classi di algoritmi MAC:

=== A ripartizione delle risorse del canale

Il canale è suddiviso in sotto-canali più piccoli e ogni nodo usa un
sotto-canale in modo esclusivo.

- TDMA (time division multiple access): l'accesso al canale avviene in round di
  durata fissa;
- FDMA (frequency division multiple access): lo spettro del canale è suddiviso
  in sotto-bande e a ogni nodo viene assegnata una sotto-banda;
- CDMA (code division multiple access): ogni nodo ottiene un codice che cambia a
  una frequenza maggiore di quella con cui cambiano i bit;

#starlight.img(
  "images/tdma-fdma-cdma.png",
  alt: "Confronto visivo tra le tre ripartizioni",
)

=== Ad accesso casuale

Il canale non viene suddiviso. Si cerca di minimizzare le collisioni.

==== Slotted ALOHA

Assunzioni:

- tutti i frame hanno la stessa lunghezza;
- il tempo è suddiviso in slot, ciascuno lungo quanto un pacchetto;
- i nodi sono sincronizzati e possono trasmettere solo all'inizio di uno slot;
- se due o più nodi trasmettono, tutti rilevano la collisione;

Quando un nodo ha qualcosa da inviare, lo invia nello slot immediatamente
successivo. Se non ci sono collisioni la trasmissione ha successo, altrimenti il
nodo ritrasmette il pacchetto con probabilità $p$ in ogni slot fino al successo.

Nella versione non-slotted (senza sincronizzazione), la trasmissione avviene
immediatamente, ma aumenta il rischio di collisioni e quindi diminuisce
l'efficienza.

==== Carrier sense multiple access (CSMA)

I protocolli CSMA ascoltano il canale prima di inviare: se è vuoto si può
trasmettere, altrimenti si aspetta.

Il tempo da aspettare dipende dalla versione del protocollo:

- $0$-persistente: un tempo casuale più lungo del tempo di trasmissione;
- $1$-persistente: il nodo invia il suo messaggio immediatamente dopo che
  l'altro ha finito;
- $p$-persistente: il nodo attende che il canale si liberi, dopodiché trasmette
  il frame con probabilità $p$;

#starlight.caution(title: "Periodo di vulnerabilità", [
  Periodo che passa da quando il nodo inizia a trasmettere a quando gli altri
  nodi rilevano che il canale è occupato.
])

#starlight.img(
  "images/confronto-mac-accesso-casuale.png",
  alt: "Confronto tra protocolli MAC ad accesso casuale",
)

=== A turni

I nodi accedono al canale a turno. La durata del turno può essere variabile a
seconda delle necessità di trasmissione.

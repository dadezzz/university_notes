#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "L'architettura peer to peer e il protocollo BitTorrent: le tecniche di ricerca dei file, directory centralizzata, query flooding e copertura gerarchica.",
  lang: "it",
  title: "Peer to peer, BitTorrent e ricerca di file",
))

= Architettura Peer to Peer (P2P)

L'architettura P2P è un approccio alternativo al modello client-server, che può
presentare benefici soprattutto quando si devono trasferire grandi quantità di
dati.

#starlight.note([
  La distribuzione di file di grandi dimensioni da un singolo server (ad un gran
  numero di client) è spesso limitata dal suo bitrate di upload piuttosto che da
  quello di download dei client o dal passaggio attraverso la rete.
])

I protocolli P2P sono definiti da alcune caratteristiche comuni:

- non c'è un server sempre attivo;
- coppie arbitrarie di host comunicano direttamente tra loro;
- i peer non sono sempre attivi e possono cambiare indirizzo IP;

== BitTorrent

Il protocollo BitTorrent si usa per scambiarsi file in maniera P2P.

BitTorrent assegna alcuni nomi specifici ad alcune parti del protocollo:

- *torrent*: gruppo di peer che si scambiano le parti del file;
- *tracker*: host che tiene traccia dei peer che partecipano al torrent; quando
  un peer vuole connettersi può scaricare la lista degli altri host attivi;
- *chunk*: una frazione del file intero (tipicamente 256 kB);
- *seeder*: peer che rimane collegato alla rete quando finisce il suo download;
- *leecher*: peer che non ha ancora completato il download del file;

Il protocollo si basa sullo scambio di parti di file: in un dato istante un peer
può richiedere ad altri host se hanno la parte che gli manca e scaricarla.
Successivamente diventa in grado di fornire quella parte ad altri nuovi host.

== Ricerca di informazioni

Uno dei problemi dei protocolli P2P è riuscire a conoscere quali file sono
presenti nella rete formata dagli host attivi in un dato momento.

Le 3 soluzioni più diffuse sono:

- *directory centralizzata*:
  - un host (indice) tiene traccia dinamicamente della posizione dei file tra i
    vari peer;
  - un peer comunica periodicamente quali file possiede;
  - un nuovo peer consulta l'indice per sapere a quali host connettersi;

  #starlight.caution(title: "Problemi della directory", [
    - unico punto di fallimento;
    - collo di bottiglia per le prestazioni;
  ])

- *query flooding*:
  - un peer conosce $n$ peer vicini (sa quali file ci sono su quegli host);
  - se gli serve un nuovo file chiede a loro se sanno dov'è;
  - se i peer vicini non lo sanno, chiedono a loro volta ai loro $n$ vicini;
  - prima o poi qualcuno riuscirà a connettersi ad un host che ha il file;

- *copertura gerarchica*:
  - è una combinazione tra il metodo della directory e quello del query
    flooding;
  - i peer sono suddivisi in gruppi, con un leader che tiene traccia di tutti i
    file sui peer del suo gruppo;
  - il query flooding avviene solo tra i leader dei gruppi, limitando il
    traffico generato;

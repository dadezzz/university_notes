#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  lang: "it",
  title: "Livello di rete: datagrammi IP e indirizzi IPv4",
  description: "Il livello di rete: forwarding e routing, formato del datagramma IPv4, MTU e frammentazione, gerarchia degli indirizzi IPv4 divisi in prefisso e suffisso.",
))

= Livello di rete

Lo scopo del livello 3 è quello di spostare datagrammi da un host ad un altro,
soprattutto quando essi si trovano su reti locali diverse.

Al livello 3 i router possono ispezionare le header dei datagrammi per prendere
decisioni di inoltro.

Le sue funzioni principali sono 2:

- inoltro (*forwarding*): consiste nello spostamento (ed eventuale modifica) del
  pacchetto dall'ingresso all'uscita di un router;
- instradamento (*routing*): consiste nel determinare il percorso che il
  pacchetto deve seguire;

Si possono distinguere 2 parti del livello:

- *data plane*: trasporta i dati dell'utente, si occupa soprattutto del
  forwarding;
- *control plane*: scambia messaggi per capire la miglior strategia di routing.

= Protocollo IP

Il protocollo IP si occupa del trasporto dei dati. Stabilisce:

- convenzioni sugli indirizzi da usare;
- il formato dei datagrammi;
- le politiche di gestione dei pacchetti.

== Datagramma IP (IPv4)

#table(
  columns: 2,
  table.header([*Sezione*], [*Lunghezza in bit*]),
  [versione (4 o 6)], [4],
  [lunghezza header (in byte)], [4],
  [tipo di servizio], [8],
  [lunghezza datagramma (in byte)], [16],
  [id datagramma], [16],
  [flags], [3],
  [offset frammento], [13],
  [ttl], [8],
  [protocollo superiore (ad esempio TCP o UDP)], [8],
  [checksum header], [16],
  [indirizzo IP sorgente], [32],
  [indirizzo IP destinazione], [32],
  [opzioni (campo non obbligatorio)], [0-?],
  [padding], [bit mancanti per arrivare a `% 32 == 0`],
)

In particolare:

- tipo di servizio: usato raramente, perché ogni router dovrebbe conoscere tutti
  i possibili tipi di servizio;
- id, flags, offset frammento: un datagramma può essere frammentato quando i
  layer inferiori non supportano dimensioni così grandi. Questi dati servono a
  ricomporre il datagramma intero;
- ttl: diminuisce di 1 ad ogni hop di router (per impedire loop di pacchetti).

== MTU e frammentazione

Ciascun tipo di hardware specifica un limite di dati che una trasmissione può
trasportare (MTU). Quindi ciascun datagramma deve contenere al più un numero di
byte pari alla MTU.

Il router che esegue la frammentazione è quello collegato alla rete con MTU più
piccola. La ricomposizione viene poi fatta soltanto a destinazione (i frammenti
possono anche seguire percorsi diversi).

Significato dei flag:

- D (do not fragment): il mittente indica che il datagramma non deve essere
  frammentato; se un router non può inoltrarlo senza frammentarlo, lo scarta e
  invia un messaggio ICMP di errore;
- M (more fragments): indica se seguono altri frammenti del datagramma (vale 1
  per tutti i frammenti tranne l'ultimo).

=== Svantaggi della frammentazione

- Un datagramma frammentato non può essere ricomposto fino a quando non sono
  arrivati tutti i frammenti.
- Il ricevitore deve memorizzare i frammenti finché non arriva l'ultimo (entro
  un timeout specificato dal protocollo IP).
- La frammentazione si è rivelata un bersaglio per attacchi DDoS, quindi molti
  router la disabilitano e in IPv6 i router non la supportano.

= Indirizzi IPv4

Un indirizzo IPv4 è una stringa di 32 bit associata ad un'interfaccia di rete.
Un'interfaccia è la connessione tra l'host e il router (collegamento fisico).
Ognuna ha un indirizzo differente.

Ogni indirizzo IP pubblicamente raggiungibile deve essere unico. I router
prendono decisioni basandosi unicamente sull'indirizzo di destinazione.

== Gerarchia degli indirizzi

Gli indirizzi sono generalmente divisi in 2 parti:

- prefisso: indica la rete alla quale l'host è collegato (netID). Un netID
  identifica una LAN.
- suffisso: identifica un'interfaccia collegata a quella rete (hostID).

Una volta la divisione tra prefisso e suffisso era prestabilita e le reti erano
divise in classi: la classe A aveva un suffisso di 24 bit, la classe B di 16 bit
e la classe C di 8 bit.

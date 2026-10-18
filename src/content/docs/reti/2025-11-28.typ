#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  lang: "it",
  title: "Indirizzi IP speciali, ARP, ICMP e DHCP",
  description: "Indirizzi IP speciali come broadcast, localhost, multicast e link local, ARP con caching e proxying, messaggi ICMP e assegnazione automatica via DHCP.",
))

= Indirizzi IP speciali

Esistono alcuni tipi di indirizzi IP speciali che non possono essere assegnati
agli host:

== Indirizzi di tutta la rete

Sono usati per riferirsi al prefisso usato per una certa rete e si indicano
impostando l'hostID a 0.

== Indirizzo broadcast di una rete

Si usa per inviare un pacchetto a tutti gli host di una rete. Questo pacchetto
viaggia su internet come un singolo pacchetto. Il router di destinazione lo
distribuisce a tutti gli host sulla sua rete.

Si indica impostando tutti i bit dell'hostID a 1.

== Indirizzo broadcast di rete locale

Si usa per inviare un pacchetto a tutti gli host della rete locale. I pacchetti
inviati a questo indirizzo non escono mai dalla rete locale.

Si indica con l'indirizzo 255.255.255.255, che corrisponde a 32 bit a 1.

Quando un host non ha un indirizzo IP valido (e quindi non conosce su che rete
si trova), allora esso manda i datagrammi all'indirizzo broadcast locale.

== Questo computer

Quando un host si accende, deve ricevere un indirizzo IP prima di essere in
grado di usare i protocolli superiori. Però anche la comunicazione con il router
richiede IP, quindi inizialmente l'host usa l'indirizzo 0.0.0.0.

== Localhost

Gli indirizzi localhost, che corrispondono a quelli nella subnet 127.0.0.0/8, si
usano per connettere applicazioni di rete sullo stesso computer.

Nessun pacchetto inviato sull'interfaccia di loopback lascia il computer.

== Indirizzi multicast

Gli indirizzi multicast servono ad inviare pacchetti ad un gruppo di host
distribuito su internet. Questi indirizzi hanno prefisso binario 1110, ovvero
sono quelli da 224.0.0.0 a 239.255.255.255.

I router si occupano di copiare il traffico su diverse sottoreti quando
necessario.

#starlight.note([
  Purtroppo il multicast è raramente supportato su internet e il suo traffico
  viene spesso bloccato.
])

== Indirizzi link local

La sottorete 169.254.0.0/16 viene riservata per consentire le comunicazioni
quando un host non riesce a trovare un indirizzo IP.

Ogni host sulla rete sceglie a caso un IP da questa sottorete e diventa in grado
di comunicare con gli altri della stessa rete, ma non con l'esterno.

= Indirizzi IP per i router

Ad ogni router si assegnano 2 o più indirizzi IP, dato che per definizione essi
devono collegare almeno 2 reti.

= Address Resolution Protocol (ARP)

Quando l'host destinatario di un datagramma si trova sulla stessa rete, è meglio
inviarlo direttamente anziché passare per il router. In questo caso bisogna
conoscere l'indirizzo MAC del ricevente.

#starlight.tip([
  Per sapere se questo è il caso basta guardare se il netID è lo stesso.
])

Il protocollo ARP si occupa di cercare qual è l'indirizzo MAC dell'host da
raggiungere:

1. Se l'indirizzo IP del destinatario è C, il mittente invia in broadcast una
  richiesta per cercare il MAC dell'host con IP C.
2. La richiesta raggiunge tutti gli host sulla rete.
3. L'host con l'indirizzo cercato risponde con il suo indirizzo MAC.

Il protocollo ARP si usa solo per comunicazioni punto-punto sulla stessa rete
(eccetto in casi particolari). Altrimenti si invia il pacchetto al router,
usando ARP per trovare il suo indirizzo MAC.

== Messaggio ARP

Il formato del messaggio ARP è semplice:

#table(
  columns: 2,
  table.header([*Sezione*], [*Lunghezza in bit*]),
  [hardware address type], [16],
  [protocol address type], [16],
  [haddr len], [8],
  [paddr len], [8],
  [operation], [16],
  [sender haddr], [48],
  [sender paddr], [32],
  [target haddr], [48],
  [target paddr], [32],
)

Il messaggio viene incapsulato direttamente in un frame di livello 2.

== ARP caching

Per evitare di inviare messaggi ARP per ogni datagramma da inviare, ogni host
mantiene in memoria le risposte ricevute.

L'invalidazione avviene periodicamente: di solito ogni 30 secondi si eliminano
le corrispondenze più vecchie.

== ARP proxying

Un proxy ARP è un host che restituisce un indirizzo MAC facendo le veci di un
host che si trova su una rete diversa.

Ad esempio, abbiamo la stessa rete ma con 2 gruppi di host separati da un
router. Il router si occupa di rispondere con il proprio MAC al posto degli host
dell'altro gruppo, in modo che esso possa effettuare un controllo dell'accesso.

= Internet Control Message Protocol (ICMP)

Il protocollo ICMP è usato in parallelo a quello IP e si usa per notificare
errori al mittente di un datagramma e per eseguire operazioni di gestione della
rete.

I messaggi ICMP viaggiano anch'essi su datagrammi IP.

== Messaggio ICMP

#table(
  columns: 2,
  table.header([*Sezione*], [*Lunghezza in bit*]),
  [tipo], [8],
  [codice], [8],
  [checksum], [16],
)

Il tipo di messaggio denota il contenuto:

#table(
  columns: 2,
  table.header([*Tipo*], [*Descrizione*]),

  [Destination unreachable], [Il pacchetto non può essere consegnato],

  [Port unreachable],
  [Il destinatario non ha processi che ascoltano sulla porta specificata],

  [Time exceeded], [Il TTL dell'header IP è sceso a 0],
  [Parameter problem], [L'header IP contiene valori non validi],
  [Source quench], [Chiede alla sorgente di rallentare l'invio dei dati],
  [Redirect],
  [Dice all'host un router migliore a cui inoltrare i datagrammi per una certa
    destinazione],

  [Echo request/reply],
  [Il ricevente risponde con lo stesso valore usato nella richiesta],

  [Timestamp request/reply],
  [Come echo ma il valore è l'orologio locale del router],

  [Router advertisement/solicitation],
  [Per proporsi come router o rilevare i router nelle vicinanze],

  [Fragmentation needed],
  [Il datagramma ha il flag 'non frammentare' ma eccede l'MTU],
)

I messaggi ICMP in rete si comportano come altri dati contenuti in un datagramma
IP, tranne per il fatto che gli errori causati da essi vengono scartati (per non
congestionare la rete).

= DHCP

DHCP è un protocollo che consente di assegnare un indirizzo IP a un host in
maniera automatica.

Funzionamento:

1. L'host invia un messaggio DHCP discover.
2. Il server DHCP risponde con DHCP offer.
3. L'host richiede un indirizzo con DHCP request.
4. Il server invia un DHCP ack.

L'indirizzo ottenuto può essere memorizzato e richiesto direttamente la volta
successiva, rendendo opzionali i messaggi di discover e offer.

L'indirizzo fornito da DHCP rimane valido per un tempo limitato (lease). Quando
il prestito finisce, il client può negoziare un'estensione del prestito o
cambiare IP.

Se il server nega l'estensione del lease, il client deve smettere di usare l'IP.

== Messaggio DHCP

DHCP usa UDP; in caso di perdita del messaggio, lo rinvia semplicemente.

#table(
  columns: 2,
  table.header([*Sezione*], [*Lunghezza in bit*]),
  [op (specifica se il messaggio è una richiesta o una risposta)], [8],
  [htype (tipo di hardware)], [8],
  [hlen (lunghezza indirizzo di livello 2)], [8],
  [hops (quanti server hanno inoltrato la richiesta)], [8],
  [transaction id (uguale tra richiesta e risposta)], [32],
  [seconds elapsed (secondi passati dall'inizio della richiesta di indirizzo)],
  [16],

  [flags], [16],
  [client IP], [32],
  [your IP (indirizzo offerto al client DHCP)], [32],
  [server IP], [32],
  [relay agent IP (indirizzo del relay che ha inoltrato la richiesta)], [32],
  [client MAC], [128],
  [server hostname], [512],
  [boot file name], [1024],
  [options], [variabile],
)

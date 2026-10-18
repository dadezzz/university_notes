#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Header e indirizzi IPv6, transizione da IPv4, architettura e commutazione dei router, protocolli di routing, algoritmo di Dijkstra, OSPF e sistemi autonomi.",
  lang: "it",
  title: "IPv6, router e protocolli di routing: OSPF e AS",
))

= IPv6

IPv6 è una nuova versione del protocollo IP, pensata per ampliare la quantità di
indirizzi disponibili.

Sono state fatte anche alcune modifiche che permettono di processare i
datagrammi più velocemente:

- header con lunghezza fissa di 40 byte;
- frammentazione operata solo dal mittente, non più dai router;
- rimozione del checksum;
- rimozione del campo options;

Sono inoltre stati aggiunti dei nuovi messaggi di errore su ICMPv6.

== Header IPv6

#table(
  columns: 2,
  table.header([*Sezione*], [*Lunghezza in bit*]),
  [versione (costante 6)], [4],
  [priority (priorità tra datagrammi dello stesso flusso)], [8],
  [flow label (uguale per tutti i datagrammi nello stesso flusso)], [20],
  [payload length], [16],
  [next header (identifica il protocollo L4 incapsulato)], [8],
  [hop limit (come TTL su IPv4)], [8],
  [source address], [128],
  [destination address], [128],
)

== Transizione tra IPv4 e IPv6

Non tutti i router su internet supportano IPv6. Come si può far coesistere reti
IPv4 e IPv6 fino a quando non finirà la transizione?

I router che supportano il tunneling sono in grado di incapsulare datagrammi
IPv6 all'interno di quelli IPv4. Il router all'estremità del tunnel dovrà poi
estrarre il datagramma IPv6 originale e instradarlo normalmente.

== Indirizzi IPv6

Gli indirizzi IPv6 sono lunghi 128 bit e a differenza di quelli IPv4 si scrivono
in notazione esadecimale.

Le cifre si scrivono in gruppi da 4. Gli zeri non significativi all'inizio di
ogni gruppo possono essere omessi. Al posto di un'unica sequenza di gruppi tutti
nulli si può usare la notazione speciale `::`:

- `2a03:2880:f108:0083:face:b00c:0000:25de -> 2a03:2880:f108:83:face:b00c:0:25de`;
- `2a03:2880:f108:0000:0000:0000:0000:25de -> 2a03:2880:f108::25de`;

I prefissi e le sottoreti funzionano come in IPv4, con la stessa notazione di
netmask.

=== Indirizzi speciali

- `::/128` corrisponde a `0.0.0.0`;
- loopback: `::1/128` corrisponde a `127.0.0.1`;
- IPv4 in IPv6: `::ffff:c1af:3710` corrisponde a `193.175.55.16`;
- multicast: `ff00::/8` corrisponde a `224.0.0.0/4`;
- link-local: `fe80::/10` corrisponde a `169.254.0.0/16`;

= Routing

Supponiamo che un host $A$ voglia inviare un datagramma IP ad un altro host $B$,
su una rete separata e separati da un router $R$.

+ $A$ crea il datagramma e ottiene l'indirizzo MAC di $R$ attraverso ARP;
+ $A$ invia il datagramma incapsulato in un frame di livello 2 al router;
+ $R$ riceve il frame, estrae il datagramma e lo incapsula di nuovo in un frame
  con l'indirizzo MAC del prossimo hop ($B$, se la sua rete è direttamente
  collegata a $R$);

La risposta di $B$ seguirà lo stesso percorso al contrario.

= Architettura di un router

In generale un router si può dividere in 2 sezioni:

- control plane: implementato in software, si occupa della risoluzione della
  route migliore;
- data plane: implementato come hardware specifico, si occupa dell'inoltro dei
  dati;

#starlight.img(
  "images/architettura-router.png",
  alt: "Schema architettura di un router",
)


== Porte d'ingresso

Ogni singola porta di ingresso si occupa della ricezione dei bit e del
buffering. Inoltre ogni porta consulta la tabella di inoltro per trovare la
porta d'uscita corretta.

#starlight.img(
  "images/porta-ingresso-router.png",
  alt: "Porta di ingresso di un router",
)

Le porte d'uscita sono composte alla stessa maniera, solamente con l'ordine dei
componenti invertito.

== Sistema di commutazione

Il sistema di commutazione si occupa di trasferire i pacchetti dalla porta di
ingresso a quella d'uscita. Il tasso di commutazione è la velocità alla quale i
pacchetti vengono trasferiti. Di solito è un numero multiplo della velocità
supportata su ogni ingresso.

#starlight.img(
  "images/sistemi-di-commutazione-router.png",
  alt: "Sistemi di commutazione di un router",
)


- *Commutazione a memoria*: è il sistema più semplice, supportato da qualsiasi
  computer dato che tutto il processo è svolto dalla CPU.
- *Commutazione a bus*: c'è un unico bus dati condiviso all'interno del router.
  La velocità di commutazione è limitata dalla banda del bus.
- *Commutazione a matrice*: gli ingressi e le uscite sono collegati da una
  matrice di connessioni. Si possono superare i limiti di velocità del sistema a
  bus.

Un sistema di commutazione più lento della somma delle velocità delle porte
d'ingresso causa accodamenti e perdita di pacchetti quando i buffer vanno in
overflow.

== Memoria necessaria nei buffer di un router

Con $N$ flussi di dati e link di capacità $C$, la memoria raccomandata è:

$
  ("RTT" C) / sqrt(N)
$

= Protocolli di instradamento

Finora abbiamo visto router in cui la tabella di inoltro era già configurata.
Ora vediamo come essa viene creata in maniera automatica.

Un protocollo di routing deve trovare il miglior percorso per collegare 2 host
attraverso una rete di router. La metrica che definisce il percorso migliore è
solitamente il costo (economico) minore, oppure la velocità più alta o la minor
congestione.

== Algoritmi di routing

Gli algoritmi di routing possono essere classificati in 2 maniere:

- rispetto al tipo di informazioni che un router conosce:
  - globali: il router conosce tutta la topologia della rete, si usa negli
    algoritmi _link state_;
  - distribuite: il router conosce solo gli altri router a cui è direttamente
    collegato, si usa negli algoritmi _distance vector_;
- rispetto alla velocità di cambiamento dei percorsi:
  - statici: il percorso non cambia;
  - dinamici: il percorso cambia periodicamente, solitamente a causa del cambio
    dei costi nei link;

== Algoritmo di Dijkstra

Dijkstra è un algoritmo iterativo (dopo $k$ iterazioni si conosce il percorso a
costo minimo verso $k$ destinazioni) che assume che i nodi conoscano tutta la
topologia di rete (le informazioni sullo stato circolano in broadcast).

Dati:

- `N`: insieme di tutti i nodi;
- `c(x, y)`: costo del link tra 2 nodi;
- `D(v)`: costo del percorso verso il nodo `v`;
- `p(v)`: predecessore di `v` lungo il cammino;
- `N'`: insieme di nodi per cui il costo minimo è stato già determinato;

```
N' = { u };

for v in N:
  if (v adiacente a u):
    D(v) = c(u, v);
    p(v) = u;
  else:
    D(v) = oo;

while N' != N:
  trova w not in N' con D(w) minimo;
  aggiungi w a N';

  for v adiacente a w e v not in N':
    if (D(w) + c(w, v) < D(v)):
      D(v) = D(w) + c(w, v);
      p(v) = w;
```

dove $u$ è il nodo sorgente. L'algoritmo ha una complessità $O(n^2)$ nella
versione con scansione lineare mostrata sopra. Inoltre i percorsi calcolati
possono oscillare se i costi dipendono dal traffico, rendendo l'instradamento
instabile.

= Autonomous Systems

Internet è formata da moltissime sottoreti, ognuna appartenente a qualche
entità. Idealmente ciascuna di esse dovrebbe essere autonoma e capace di
collegarsi a tutte le altre.

Un gruppo di router sotto lo stesso controllo amministrativo è detto *Autonomous
System* (AS). Ogni AS è identificato da un numero (ASN), assegnato centralmente
da IANA (tramite i RIR).

Si formano quindi 2 tipologie di routing:

- intra-AS: dove si conoscono e si controllano tutti i router;
- inter-AS: dove bisogna interfacciarsi con sistemi sconosciuti;

== Open Shortest Path First

OSPF è un protocollo di routing link-state intra-AS. Sfrutta l'algoritmo di
Dijkstra per calcolare il percorso migliore.

Le informazioni sullo stato della rete sono inviate tramite multicast
all'indirizzo `224.0.0.5`. Esse viaggiano su datagrammi IP, senza alcun livello
di trasporto.

Si distinguono 3 procedure:

- _hello_: i router li scambiano periodicamente con i vicini per segnalare che
  sono attivi;
- _exchange_: scambiati tra vicini appena entrati in rete per informarli della
  topologia di rete attuale;
- _flooding_: informa tutti i router di cambi nello stato dei link;

=== OSPF gerarchico

L'OSPF gerarchico è usato in reti con molti router. Di solito si usa una
gerarchia a 2 livelli con backbone e aree locali.

I messaggi con il link state circolano solo nelle sottoreti, e tutti i router
conoscono solo uno shortest path verso le altre aree.

Solo i router di backbone si connettono ad altri AS tramite BGP.

== Problemi dei protocolli link state

L'unica cosa che influenza la scelta dei percorsi è il costo di un link. Quindi
un operatore potrebbe agire sui propri link per controllare il traffico che
passa per la propria rete.

Quindi diventa possibile per un AS fare traffic engineering, anche
prioritizzando certi vicini rispetto ad altri.

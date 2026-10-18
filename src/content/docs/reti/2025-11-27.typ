#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Dall'ICANN all'indirizzamento classless: maschere di rete, notazione CIDR, tabelle di routing con next-hop, indirizzi pubblici e privati, NAT e port forwarding.",
  lang: "it",
  title: "Indirizzamento classless, tabelle di routing e NAT",
))

= ICANN

L'Internet Corporation for Assigned Names and Numbers (ICANN) è l'entità creata
per gestire l'assegnazione degli indirizzi IP e per arbitrare eventuali dispute.

L'assegnazione degli indirizzi IP viene gestita dai registri regionali (RIR,
Regional Internet Registry), che li suddividono tra gli ISP, i quali poi li
assegnano ai clienti.

= Indirizzamento classless

Con la rimozione delle classi di indirizzi, la suddivisione tra prefisso e
suffisso diventa completamente arbitraria, quindi diventa possibile partizionare
le reti in maniera molto più efficiente.

In caso un router abbia su un'interfaccia una rete con prefisso di lunghezza `m`
e su un'altra una rete con prefisso di lunghezza `n > m`, e l'indirizzo di
destinazione appartenga a entrambe, allora esso darà precedenza all'interfaccia
con prefisso `n`, seguendo la regola del prefisso più lungo.

== Maschere di rete

Dato che la dimensione del prefisso non è più indicata dalla classe di
appartenenza della rete, si usa una maschera di 32 bit in cui quelli a 1
indicano i bit del prefisso.

Questa informazione si chiama maschera di rete (subnet mask) perché i router (a
cui non interessa l'hostID) possono eseguire un AND logico per mascherare
l'indirizzo e tenere solo la parte di netID.

== CIDR

La notazione Classless Inter-Domain Routing (CIDR) sintetizza le informazioni di
netID e della relativa subnet mask con `ddd.ddd.ddd.ddd/m`, dove `m` indica il
numero di bit uguali a 1 nella maschera.

== Tabella di routing

La tabella di routing viene usata dai router per capire come indirizzare il
traffico sulle varie interfacce.

*Default gateway*: quando nessuna voce della tabella di routing corrisponde
all'indirizzo di destinazione, si ha una destinazione catch-all `0.0.0.0/0` che
indica dove inviare tutti i pacchetti con destinazione non specificata.

La tabella di routing specifica anche il next-hop, cioè il router a cui
inoltrare i pacchetti. In questo modo un router connesso ad altri può sapere a
quale router inviare ogni pacchetto in base all'indirizzo di destinazione.

#starlight.img(
  "images/esempio-routing-table.png",
  alt: "Esempio di routing table",
)

= Indirizzi IP pubblici e privati

La maggioranza dei $2^32$ indirizzi IPv4 è pubblica e può essere assegnata ad
host raggiungibili su Internet. Alcuni invece sono riservati e si usano per
costruire reti private (i router su Internet li bloccano).

- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

Il NAT si usa per consentire agli host su reti private di connettersi a
Internet.

= Network Address Translation (NAT)

Il NAT è un dispositivo (di solito un router) che ha un indirizzo IP pubblico e
uno privato e che fa da proxy per gli altri host sulla rete privata.

Quando un host privato invia un pacchetto:

1. Il NAT cambia l'IP sorgente con il suo e la porta sorgente con una libera su
  di esso, poi memorizza la corrispondenza in una tabella.
2. Invia il datagramma verso l'esterno.
3. L'altra parte risponde all'IP pubblico del NAT sulla porta tradotta.
4. Il NAT consulta la tabella e sovrascrive l'IP di destinazione con quello
  privato e la porta con quella iniziale.

Il numero massimo di connessioni simultanee è limitato quindi dal numero di
porte disponibili sull'indirizzo pubblico ($2^16$).

Inoltre il NAT viola l'architettura a strati perché modifica i segmenti di
livello 4.

Per connettersi ad un host dietro a NAT si usa il port forwarding: si dice al
router pubblico di inviare tutti i segmenti ricevuti su una certa porta alla
porta corrispondente dell'host privato.

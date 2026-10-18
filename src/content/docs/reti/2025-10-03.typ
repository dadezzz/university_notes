#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Tipi di malware e attacchi di rete come DDoS, sniffing, spoofing e replay, architetture applicative client-server, P2P e ibride, con socket e indirizzamento.",
  lang: "it",
  title: "Sicurezza di rete, malware e socket applicativi",
))

= Sicurezza di rete

La visione originaria della rete Internet era quella di 'un gruppo di utenti che
si fidavano l'uno dell'altro su una rete trasparente'. Come abbiamo visto,
questa visione non ha funzionato.

== Malware

Esistono diversi tipi di malware che possono essere condivisi e installati anche
involontariamente attraverso la rete Internet.

- virus, worm o trojan sono categorie di software che compiono azioni dannose a
  scapito dell'utente infettato:
  - virus: oggetto ricevuto tramite e-mail o download e avviato dall'utente;
  - worm: oggetto ricevuto passivamente e che si esegue automaticamente;
  - trojan: parte dannosa nascosta in un software altrimenti utile;
- spyware: trasmette all'attaccante informazioni raccolte sull'host dell'utente;
- botnet: gruppi di host arruolati per attività di spam e attacchi DDoS;
- malware auto-replicante: malware che passa in maniera automatica da un host
  all'altro;

== Tipologie di attacchi sulla rete

- *attacco DDoS*: gli attaccanti inviano alla vittima più dati di quanti ne
  possa gestire, negando il servizio agli utenti legittimi.
- *packet sniffing*: gli attaccanti intercettano pacchetti lungo il loro
  percorso sulla rete per estrarre informazioni sulla vittima.
- *IP spoofing*: un host invia pacchetti impostando l'indirizzo sorgente di un
  altro host, in modo che i pacchetti di risposta creino un danno alla vittima.
- *record and playback*: simile al packet sniffing, l'attaccante reinvia
  pacchetti sniffati per (ad esempio) far compiere un'azione più volte
  all'utente o usare credenziali anche se cifrate.

= Livello applicazione

Cosa significa creare un'applicazione di rete?

- il programma viene eseguito su host diversi;
- comunica attraverso la rete;
- non occorre predisporre i dispositivi del nucleo della rete per supportare il
  programma;

Tipi di architetture:

- client-server: i client fanno richieste o inviano dati al server, che ha una
  posizione di controllo;
- peer-to-peer (P2P): tutti sullo stesso livello. Ad esempio, nei torrent, si
  ricevono parti di file ma allo stesso tempo si inviano ad altri host sulla
  rete;
- ibrida: architetture P2P ma con un server che fornisce autenticazione e
  controllo;

== Socket

Per inviare messaggi ad altri host o processi (se sullo stesso host),
un'applicazione deve aprire una *socket*.

Si può paragonare il socket a una porta: un processo invia messaggi attraverso
la sua porta (che deve rimanere aperta) e l'altro processo ricevente deve avere
una porta aperta per ricevere quei messaggi.

Dopo che il messaggio è stato scritto sul socket, ci si affida alla rete (e ai
livelli inferiori) per trasportare il pacchetto alla destinazione.

== Indirizzamento

Un processo invia un messaggio a uno specifico destinatario attraverso un
indirizzo. Per IPv4 ogni host ha un indirizzo IP univoco di 32 bit.

Non basta sapere l'indirizzo, dato che su ogni host potrebbero esserci più
processi in ascolto.

Si usa infatti anche un numero di porta (a 16 bit) che identifica un socket in
ascolto sull'host ricevente.

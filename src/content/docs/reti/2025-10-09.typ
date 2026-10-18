#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Confronto tra TCP e UDP e funzionamento di HTTP: messaggi di richiesta e risposta, metodi, codici di stato, cookie, proxy e cache con GET condizionale.",
  lang: "it",
  title: "TCP, UDP e HTTP: messaggi, metodi, cookie e cache",
))

= Protocolli di trasporto Internet

Oggi si usano principalmente due protocolli di layer 4 per trasferire i
pacchetti:

- Transmission Control Protocol (TCP):
  - necessità di creare una connessione tra host;
  - garantisce che l'altro host riceva i dati in maniera ordinata;
  - controllo di flusso: il destinatario specifica quanti byte il mittente può
    inviare;
  - controllo della congestione: invia meno dati quando la rete è
    sovraccaricata;
- User Datagram Protocol (UDP):
  - trasferimento di dati inaffidabile;
  - non offre alcuna garanzia sull'arrivo dei dati all'altro host;
  - utile in applicazioni che richiedono bassa latenza;

= HTTP

https://developer.mozilla.org/docs/Web/HTTP

Il protocollo HTTP è stato proposto da Tim Berners-Lee ed oggi è il protocollo
che governa la maggior parte dei trasferimenti di dati sul web.

Una pagina web è formata da un file di base in formato HTML (HyperText Markup
Language), che può includere riferimenti a diversi oggetti.

Ogni oggetto è referenziato da un URL (Uniform Resource Locator).

Il protocollo HTTP si basa su un modello client-server: il client invia
richieste al server e quest'ultimo risponde. Al di sotto usa il protocollo TCP
per inviare i dati; di solito il server ascolta sulla porta 80.

HTTP è un protocollo stateless: il server non mantiene informazioni sulle
richieste fatte dal client. Se c'è bisogno di implementare sessioni è necessario
farlo al di sopra del protocollo.

#starlight.note([
  Per migliorare la performance, di solito i server lasciano la connessione TCP
  aperta in modo che i client possano riutilizzarla per evitare l'overhead di
  apertura per ogni richiesta.
])

== Tipologie di messaggio

HTTP è un protocollo testuale (usa caratteri ASCII) e distingue tra due tipi di
messaggi. Ogni riga del messaggio è separata da un carriage return + line feed
(`\r\n`).

- messaggio di richiesta:

  ```
  GET /some-file HTTP/1.1
  Host: example.com
  ```

  La prima riga specifica, in ordine, il metodo, il path e la versione HTTP. Poi
  seguono una o più righe di header in formato `header-name: header-value`.

  La fine della sezione degli header è segnalata da una riga vuota; tutto ciò
  che viene dopo è arbitrario e rappresenta il corpo della richiesta.

- messaggio di risposta:

  ```
  HTTP/1.1 200 OK
  Content-Length: 678
  Content-Type: text/html

  <!DOCTYPE html>
  <html lang="en">
  ...
  ```

  Qui la prima riga specifica la versione HTTP, il codice di stato e la frase di
  stato. Poi il resto funziona come nella richiesta.

#starlight.tip([
  Il nome degli header è case insensitive, quindi non importa se si usano
  lettere maiuscole o minuscole.
])

== Metodi

https://developer.mozilla.org/docs/Web/HTTP/Reference/Methods

I metodi HTTP più usati sono:

- `GET`: richiede una risorsa dal server. Dovrebbe essere idempotente, ovvero
  non dovrebbe modificare dati sul server.
- `POST`: crea una risorsa nel server.
- `HEAD`: chiede una risposta identica a quella di un `GET`, ma senza il corpo
  di risposta.
- `PUT`: rimpiazza una risorsa sul server.
- `DELETE`: richiede al server di cancellare la risorsa specificata.

Altri metodi meno comuni sono `CONNECT`, `OPTIONS`, `TRACE`, `PATCH`.

== Codici di stato

Esistono molti codici numerici che indicano una specifica condizione del server.
Sono raggruppati in cinque classi in base alla prima cifra:

- `1xx`: informazioni;
- `2xx`: successo;
- `3xx`: reindirizzamento;
- `4xx`: errore del client;
- `5xx`: errore del server.

Per l'elenco completo:

- https://developer.mozilla.org/docs/Web/HTTP/Reference/Status
- https://http.cat

== Cookies

https://developer.mozilla.org/docs/Web/HTTP/Guides/Cookies

I cookie sono un meccanismo integrato in HTTP che permette al server di
identificare un client, rendendo il protocollo meno _stateless_.

1. Quando un client fa una richiesta, il server può aggiungere alla risposta uno
  o più header `set-cookie`.
2. Il client legge i loro valori e li conserva da qualche parte.
3. Alla richiesta successiva il client dovrebbe includere tutti i cookie inviati
  dal server nell'header `cookie`.

== Proxy e cache

Un proxy è un server a cui i client si connettono invece di collegarsi
direttamente al server originale.

Il server proxy può:

- filtrare richieste a siti web dannosi;
- mantenere risposte del server in cache per diminuire il carico sulla rete;

=== GET condizionale

Al giorno d'oggi i browser tengono in memoria alcuni file, in modo da non
doverli riscaricare dal server quando la pagina viene ricaricata.

*Problema*: come tenere questi file aggiornati?

Esiste un particolare header HTTP che permette di eseguire l'invalidazione della
cache sul client. Quando esso invia una richiesta al server, può includere
l'header `If-Modified-Since`. Se l'oggetto sul server è più nuovo, allora
quest'ultimo lo invierà nella risposta; altrimenti può inviare una risposta
vuota con codice di stato `304` (Not Modified).

#image(
  "images/http-if-not-modified.png",
  alt: "Diagramma di richiesta GET con if-not-modified",
)


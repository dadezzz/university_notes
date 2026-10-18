#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  lang: "it",
  title: "Versioni di HTTP, HTTPS, FTP e posta elettronica",
  description: "Panoramica su HTTP/1.0, HTTP/1.1 e HTTP/2 con frame, stream e server push, oltre a HTTPS/TLS, FTP, SMTP e formato dei messaggi di posta secondo RFC 822.",
))

= Versioni del protocollo HTTP

- `HTTP/1.0`: versione originale, ormai obsoleta in quasi tutti i sistemi.
- `HTTP/1.1`:
  - rilasciata pochi mesi dopo la 1.0;
  - aggiunge la possibilità di riutilizzare connessioni per richieste
    successive;
  - specifica alcuni nuovi header;
- `HTTP/2`:
  - si basa sul protocollo SPDY ed effettua il multiplexing di molteplici
    richieste su un'unica connessione TCP;
  - permette di assegnare una priorità alle richieste;
  - permette di comprimere gli header, per ridurre la larghezza di banda usata;
  - permette al server di anticipare l'invio di dati, senza che il client debba
    richiederli;

== Frame HTTP/2

#starlight.note(title: "Spiegazione dettagliata", [
  https://galbarnahum.com/posts/http2-part1
])

Con HTTP/1.1, se si volevano eseguire più richieste in parallelo era necessario
aprire molteplici connessioni TCP.

In HTTP/2, tutte le comunicazioni vengono eseguite su una singola connessione
TCP, che può trasmettere un qualsiasi numero di stream bidirezionali. Uno stream
può essere pensato come una connessione virtuale.

Per ogni stream viene creato un identificativo univoco e si possono impostare
diverse opzioni di priorità.

- stream id 0: riservato al controllo della connessione;
- stream id dispari: stream iniziati dal client;
- stream id pari: stream iniziati dal server;

#starlight.note(title: "Durata di uno stream", [
  Uno stream rimane aperto dall'inizio alla fine dell'invio di un messaggio.
])

Ogni messaggio è diviso in uno o più frame, racchiusi da una testata in codifica
binaria che contiene informazioni sullo stream di appartenenza, sulla lunghezza
del frame ecc.

Il multiplexing sulla connessione TCP si fa tra i vari frame inviati in uno
specifico momento.

== Server push

L'estensione _server push_ permette al server di inviare più risposte per una
singola richiesta.

Questo permette di velocizzare il caricamento di pagine web, dato che il client
non deve aspettare il file HTML per poter poi richiedere i file JavaScript e CSS
referenziati.

#starlight.note([
  A causa di difficoltà riscontrate durante l'implementazione, al giorno d'oggi
  non viene più usata.

  Si usano altri metodi come l'attributo HTML `rel="preload"` e lo status code
  `103 Early Hints`.
])

= HTTPS

HTTPS estende il protocollo HTTP inviando tutti i messaggi attraverso una
connessione cifrata, tipicamente sulla porta 443.

Il protocollo usato per la cifratura è il TLS, che definisce:

- negoziazione dell'algoritmo di cifratura da usare;
- scambio delle chiavi e autenticazione;
- cifratura simmetrica dei messaggi;

Solo i messaggi di livello 7 sono criptati; la PCI del protocollo TCP è in
chiaro.

= FTP

Il protocollo FTP si basa sul modello client-server. Vengono usate connessioni
su 2 porte:

- connessione di controllo:
  - porta 21/TCP;
  - usata per autorizzazione e invio di comandi;
- connessione dati:
  - porta 20/TCP;
  - usata per trasferire file;

+ Il client contatta il server sulla porta 21, specificando il protocollo di
  trasporto TCP.
+ Il server autorizza la connessione.
+ Il client invia comandi al server sulla connessione di controllo.
+ Il server risponde aprendo una connessione dati con il client.
+ Dopo il trasferimento di un file, la connessione viene chiusa.

== Comandi e codici di ritorno comuni

- comandi: https://www.nsftools.com/tips/RawFTP.htm
- codici di ritorno:
  https://en.wikipedia.org/wiki/List_of_FTP_server_return_codes

= SMTP

Per l'invio della posta elettronica servono 2 componenti:

- Un agente utente, che costituisce l'interfaccia utente dove si possono leggere
  e scrivere le e-mail.
- Un server di posta, che memorizza i messaggi inviati e ricevuti e che accoda e
  invia i messaggi al server del destinatario.

Il protocollo SMTP è il protocollo usato dai server di posta per scambiarsi le
e-mail. I server comunicano sulla porta 25/TCP, il ruolo di client è dato al
server che sta inviando, il ruolo di server a quello che sta ricevendo.

I messaggi sono trasmessi in formato ASCII a 7-bit.

*Esempio*: invio di un'e-mail

+ A usa il suo agente utente per comporre il messaggio da inviare a
  `b@example2.com`.
+ L'agente utente invia il messaggio al server di posta di A (`example1.com`).
+ `example1.com` apre una connessione SMTP con `example2.com` e invia il
  messaggio.
+ `example2.com` pone il messaggio nella casella di posta di B, che potrà
  leggerlo attraverso il suo agente utente.

#starlight.note([
  Per la lettura dei messaggi dal server di posta non si usa SMTP, ma IMAP, che
  vedremo più avanti.
])

== Formato dei messaggi di posta elettronica

I messaggi di posta elettronica vengono conservati sul server con un formato
standard, definito dalla RFC 822.

Sono composti da:

- un'intestazione che contiene diversi header;
- una riga vuota di separazione;
- il corpo del messaggio (soltanto caratteri ASCII);

La fine di una riga è denotata da `\r\n`.

#starlight.note(title: "Estensioni MIME", [
  Definiscono come aggiungere contenuti multimediali al messaggio.

  Alcuni header definiscono il tipo di contenuto e la codifica (di solito
  base64). Poi il contenuto MIME codificato viene messo all'interno del corpo.
])

*Esempio*:

```
Date: Fri, 19 May 2000 10:23:16 -0400 (EDT)
From: Doug Sauder <doug@penguin.example.com>
To: =?iso-8859-1?Q?Heinz_M=FCller?= <mueller@example.com>
Subject: PNG graphic
Message-ID: <Pine.LNX.4.21.0005191019440.8452-101000@penguin.example.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463757054-170444605-958746196=:8452"
This message is in MIME format. The first part should be readable text,
while the remaining parts are likely unreadable without MIME-aware tools.
Send mail to mime@docserver.cac.washington.edu for more info.
---1463757054-170444605-958746196=:8452
Content-Type: TEXT/PLAIN; charset=US-ASCII
---1463757054-170444605-958746196=:8452
Content-Type: APPLICATION/octet-stream; name="redball.png"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.21.0005191023160.8452@penguin.example.com>
Content-Description: red ball
Content-Disposition: attachment; filename="redball.png"
iVBORw0KGgoAAAANSUhEUgAAABsAAAAbCAMAAAC6CgRnAAADAFBMVEX///8A
AAABAAALAAAVAAAaAAAXAAARAAAKAAADAAAcAAAyAABEAABNAABIAAA9AAAj
AAAWAAAmAABhAAB7AACGAACHAAB9AAB0AABgAAA5AAAUAAAGAAAnAABLAABv
AACQAAClAAC7AAC/AACrAAChAACMAABzAABbAAAuAAAIAABMAAB3AACZAAC0
GRnKODjVPT3bKSndBQW4AACoAAB5AAAxAAAYAAAEAABFAACaAAC7JCTRYWHf
hITmf3/mVlbqHx/SAAC5AACjAABdAABCAAAoAAAJAABnAAC6Dw/QVFTek5Pl
rKzpmZntZWXvJSXXAADBAACxAACcAABtAABTAAA2AAAbAAAFAABKAACBAADL
ICDdZ2fonJzrpqbtiorvUVHvFBTRAADDAAC2AAB4AABeAABAAAAiAABXAACS
AADCAADaGxvoVVXseHjveHjvV1fvJibhAADOAAC3AACnAACVAABHAAArAAAP
AACdAADFAADhBQXrKCjvPDzvNTXvGxvjAADQAADJAAC1AACXAACEAABsAABP
AAASAAACAABiAADpAADvAgLnAADYAADLAAC6AACwAABwAAATAAAkAABYAADI
AADTAADNAACzAACDAABuAAAeAAB+AADAAACkAACNAAB/AABpAABQAAAwAACR
AACpAAC8AACqAACbAABlAABJAAAqAAAOAAA0AACsAACvAACtAACmAACJAAB6
AABrAABaAAA+AAApAABqAACCAACfAACeAACWAACPAAB8AAAZAAAHAABVAACO
AACKAAA4AAAQAAA/AAByAACAAABcAAA3AAAsAABmAABDAABWAAAgAAAzAAA8
AAA6AAAfAAAMAAAdAAANAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD8
LtlFAAAAAXRSTlMAQObYZgAAABZ0RVh0U29mdHdhcmUAZ2lmMnBuZyAyLjAu
MT1evmgAAAIISURBVHicY2CAg/8QwIABmJhZWFnZ2Dk4MaU5uLh5eHn5+LkF
BDlQJf8zC/EIi4iKiUtI8koJScsgyf5nlpWTV1BUUlZRVVPX4NFk1UJIyghp
6+jq6RsYGhmbKJgK85mZW8Dk/rNaSlhZ29ja2Ts4Ojkr6Li4urFDNf53N/Ow
8vTy9vH18w8IDAoWDQkNC4+ASP5ni4wKio6JjYtPSExKTnFWSE1LF4A69n9G
ZlZ2Tm5efkFhUXFySWlZlEd5RSVY7j+TkGRVdU1tXX1DY1Ozcktpa1t7h2Yn
OAj+d7l1tyo79vT29SdNSJ44SbFVdHIo9xSIHNPUaWqTpifNSJrZnK00S0U1
a/acUG5piNz/uXLzVJ2qm6dXz584S2WB1cJFi5cshZr539xVftnyFKUVTi2T
VjqvyhJLXb1m7TqoHPt6F/HW0g0bN63crGqVtWXrtu07BJihcsw71+zanRW8
Z89eq337RQ/Ip60xO3gIElX/LbikDm8T36KwbNmRo7O3zpHkPSZwHBqL//8f
lz1x2OOkyKJTi7aqbzutfUZI2gIuF8F2lr/D5dw2+fZdwpl8YVOlI+CJ4/9/
joOyYed5QzMvhGqnm2V0WiClm///D0lfXHtJ6vLlK9w7rx7vQk5SQJbFtSms
1y9evXid7QZacgOxmSxktNzdtSwwU+J/VICaCPFIYU3XAJhIOtjf5sfyAAAA
JXRFWHRDb21tZW50AGNsaXAyZ2lmIHYuMC42IGJ5IFl2ZXMgUGlndWV0NnM7
vAAAAABJRU5ErkJggg==
---1463757054-170444605-958746196=:8452--
```

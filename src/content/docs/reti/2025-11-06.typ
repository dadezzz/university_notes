#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "TCP affidabile: struttura dei segmenti, three-way handshake, MSS, chiusura soft e hard, calcolo dell'RTO secondo RFC 6298 e controllo di flusso del ricevitore.",
  lang: "it",
  title: "TCP: handshake, RTO e controllo di flusso",
))

= TCP

TCP è un protocollo punto-punto bidirezionale che garantisce un flusso di byte
affidabile e consegnato in ordine.

Esiste un meccanismo di controllo di congestione che definisce dinamicamente le
dimensioni delle finestre. Gli ACK sono cumulativi.

== Struttura di un segmento TCP

#table(
  columns: 2,
  table.header([*Sezione*], [*Lunghezza in bit*]),
  [porta sorgente], [16],
  [porta destinazione], [16],
  [numero di sequenza (byte inviati)], [32],
  [numero di ACK (byte ricevuti)], [32],
  [offset dati (lunghezza delle opzioni)], [4],
  [spazio inutilizzato], [6],
  [flag URG: dati urgenti], [1],
  [flag ACK: il segmento contiene un ACK valido], [1],
  [flag PSH: invia i dati immediatamente, senza aspettare], [1],
  [flag RST: resetta la connessione], [1],
  [flag SYN: usato per impostare i numeri di sequenza iniziali], [1],
  [flag FIN: usato per chiudere la connessione], [1],
  [lunghezza finestra di ricezione], [16],
  [checksum], [16],
  [puntatore ai dati urgenti], [16],
  [opzioni (campo non obbligatorio)], [0-320],
)


Il numero di sequenza è il numero del primo byte del segmento (rispetto al
totale dei byte inviati). Il numero di ACK è il numero di sequenza del prossimo
byte atteso dal ricevitore.

#starlight.img(
  "images/sequenza-ack-tcp.png",
  alt: "Esempio di sequenza e ACK TCP",
)

== Setup della connessione TCP

La procedura di connessione TCP avviene attraverso un three-way handshake.

+ L'host A (il client che inizia la connessione) invia un segmento con flag SYN
  a 1, porta sorgente A, porta destinazione B e numero di sequenza $x$ casuale.
+ L'host B (server in attesa di connessioni) risponde con un segmento con flag
  SYN e ACK a 1, porta sorgente B, porta destinazione A, numero di sequenza $y$
  casuale e numero di ACK $x + 1$.
+ L'host A invia un segmento con flag ACK a 1 e numero di ACK $y + 1$.

== Maximum Segment Size (MSS)

TCP non invia mai un singolo byte alla volta (a meno che non sia forzato). Cerca
invece di inviare segmenti lunghi quanto un MSS.

L'MSS è la massima lunghezza dei dati trasportati dal segmento, che dipende
dall'MTU dei livelli sottostanti e dalla conformazione di tutto il percorso che
devono compiere i pacchetti.

Per scegliere l'MSS, lo si aumenta progressivamente finché non si rileva la
perdita di un segmento.

== Chiusura soft di una connessione TCP

Le connessioni TCP sono sempre bidirezionali e quindi bisogna che la chiusura
avvenga da entrambe le parti.

La chiusura soft consiste nell'inviare un segmento con FIN=1 e ricevere un ACK.
Si possono ancora ricevere segmenti dall'altro host ma non possono contenere
dati (connessione half-closed). Quando l'altro host esegue lo stesso processo
allora la connessione viene chiusa.

== Chiusura hard di una connessione TCP

Il flag RST si usa per resettare connessioni non gestibili o che si trovano in
uno stato errato.

In questo caso l'host che invia l'RST non deve aspettare altri messaggi e può
liberare subito le risorse allocate alla connessione.

= Retransmission TimeOut (RTO)

Il retransmission timeout è il tempo che un host aspetta per ricevere un ACK,
prima di considerare l'invio fallito e riprovare la ritrasmissione.

Questo tempo dipende dall'RTT: impostarlo troppo piccolo porta a ritrasmissioni
non necessarie, mentre impostarlo troppo grande porta a una reazione lenta alla
perdita di segmenti.

Per calcolare il RTO (RFC 6298) si usano meccanismi di media mobile basati su
due valori calcolati dagli RTT precedenti ($"SampleRTT"$):

- $"EstimatedRTT" = (1 - alpha) "EstimatedRTT" + alpha "SampleRTT"$: media
  mobile esponenziale del RTT, in cui il peso dei vecchi campioni diminuisce
  esponenzialmente con $alpha$ tipicamente pari a $0.125$.
- $"DevRTT" = (1 - beta) "DevRTT" + beta abs("SampleRTT" - "EstimatedRTT")$:
  media della deviazione assoluta tra l'RTT misurato e $"EstimatedRTT"$.

L'RTO si calcola con la seguente formula:

$$
"RTO" = "EstimatedRTT" + 4 "DevRTT"
$$

Per inizializzare si pone $"EstimatedRTT" = "SampleRTT"$ e
$"DevRTT" = "SampleRTT" / 2$.

= Controllo di flusso TCP

Il controllo di flusso del protocollo TCP è un meccanismo mediante il quale il
ricevitore può controllare la velocità con cui il trasmettitore invia i dati.

Il ricevitore comunica quanto spazio libero ha nel proprio buffer di ricezione
includendo il valore nel campo 'finestra di ricezione' dell'header. Il mittente
limita la quantità di dati in volo (che non hanno ancora ricevuto un ACK) al
valore specificato.

#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Realizzazione e funzionamento di multiplexer, decoder, demultiplexer ed encoder con applicazioni per la condivisione di risorse e la selezione di memoria.",
  lang: "it",
  title: "Multiplexer, decoder, demultiplexer ed encoder",
))

= Circuiti combinatori fondamentali

Una mappa di Karnaugh è usabile con funzioni che arrivano al massimo a 4/5
variabili. Per funzioni più complesse conviene usare un metodo gerarchico: si
combinano blocchi più semplici per realizzare circuiti complessi (un po' come
passare dall'assembly al C).

== Multiplexer 4 a 1

Funzione a 4 ingressi di dato ($a$, $b$, $c$, $d$) + 2 ingressi di controllo
($s_0$ e $s_1$).

Possiamo usare il multiplexer 2 a 1 che già conosciamo per creare questo
componente più complesso. Per esempio:

- 1° livello: si sceglie tra $a$ e $b$ e tra $c$ e $d$ usando $s_0$;
- 2° livello: si sceglie tra i 2 rimasti usando $s_1$;

#starlight.img(
  "images/circuito-multiplexer-4-a-1.png",
  alt: "Circuito del multiplexer 4 a 1",
)

Il simbolo che si usa per rappresentare il multiplexer è:

#starlight.img(
  "images/simbolo-multiplexer-4-a-1.png",
  alt: "Simbolo del multiplexer 4 a 1",
)

Esempi di utilizzo:

- condivisione di risorse;
- realizzazione dispositivi programmabili;
- selezione di celle di memoria;

== Decoder

Decodificare significa passare da $n$ ingressi a $m$ uscite, dove:

- $n <= m <= 2^n$;
- ad ogni valore di ingresso corrisponde un unico valore in uscita;

Con $m$ cifre si possono rappresentare $2^m$ codici, ma se ne usano solo $2^n$.

Decodifica 2 a 1: la prima uscita vale 1 se l'ingresso vale 0, la seconda vale 1
se l'ingresso vale 1.

#starlight.img(
  "images/circuito-decoder-2-a-1.png",
  alt: "Circuito del decoder 2 a 1",
)

Il simbolo che si usa per rappresentare il decoder è:

#starlight.img(
  "images/simbolo-decoder-2-a-1.png",
  alt: "Simbolo del decoder 2 a 1",
)

Da notare che le combinazioni di uscita con tutti 0 o tutti 1 non vengono
utilizzate.

Esempio di utilizzo: scelta di celle di memoria:

- il processore mette sul bus un indirizzo a $n$ bit;
- metà dei bit indirizza le righe con una decodifica;
- l'altra metà sceglie una colonna con un multiplexer;

#starlight.note([
  Spesso si decodifica la colonna una volta e poi si cambia il valore del
  multiplexer, questo rende l'accesso sequenziale di celle di memoria
  leggermente più veloce di un tipo di accesso totalmente casuale.
])

== Demultiplexer

Prende in ingresso un dato e lo indirizza su una delle uscite selezionate da
$ceil(log_2(n))$ bit di controllo. Le uscite non selezionate hanno valore 0.

#starlight.img(
  "images/simbolo-demultiplexer-1-a-4.png",
  alt: "Simbolo del demultiplexer 1 a 4",
)

== Encoder

Fa il lavoro contrario del decoder: riduce $n$ ingressi a $m$ uscite.

Esempio di encoder 8 a 3:

#starlight.img("images/tabella-encoder-8-a-3.png", alt: "Tabella encoder 8 a 3")

*Priority encoder*: ritorna il codice binario dell'ingresso con valore 1 avente
priorità più alta. Se più ingressi hanno valore 1, restituisce quello con
priorità maggiore.

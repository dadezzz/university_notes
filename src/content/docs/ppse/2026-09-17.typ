#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Comunicazioni wireless, piattaforme Arduino, STM32 ed ESP32, bootloader, protocollo USB, selezione dei componenti, affidabilità e fatica nei circuiti.",
  lang: "it",
  title: "Microcontrollori: wireless, piattaforme e USB",
))

= Comunicazioni wireless

Alcuni modelli di microcontrollore includono periferiche di comunicazione
wireless, che rendono il loro utilizzo più flessibile:

- *Wi-Fi*: comunemente disponibile a $2.4 thick upright(G #h(-1pt) "Hz")$ o, in
  casi più rari, a $5 thick upright(G #h(-1pt) "Hz")$.
- *Bluetooth* / *Bluetooth Low Energy (BLE)*: diffuso in dispositivi wearable e
  domotica.
- *Zigbee*: supporta comunicazioni su reti mesh, star o con ripetitore,
  estendendo la rete attraverso l'instradamento del segnale.
- *LoRa*: opera a $868 thick upright(M #h(-1pt) "Hz")$ in Europa ed è usato per
  comunicazioni a lungo raggio con pochissima energia. Trova impiego in ambienti
  remoti, ad esempio in agricoltura.

= Piattaforme comuni

Abbiamo già introdotto l'RP2040, ma sul mercato ci sono altri concorrenti che
vengono comunemente utilizzati:

- *Arduino*: piattaforma con un ecosistema molto sviluppato. È facile trovare
  librerie per sviluppare, ma non sono certificate.
- *STM32*: microcontrollori professionali con una buona potenza di calcolo.
- *ESP32*: microcontrollore potente e con interfacce Wi-Fi e Bluetooth.

Indipendentemente dal controllore, bisogna configurare dei parametri a ogni
avvio. Comunemente i pin di GPIO sono configurati di default come ingressi,
quindi per accendere un LED sarà necessario usare una HAL (Hardware Abstraction
Layer, libreria di astrazione dell'hardware) per impostare le uscite.

= Bootloader e flashing

Generalmente esistono due tecniche per programmare un microcontrollore:

- *Programmatore esterno*: un dispositivo collegato al computer (tramite USB) e
  al microcontrollore trasferisce il software compilato nella memoria flash.
- *Bootloader*: una routine all'interno del microcontrollore permette al
  computer di comunicare anche quando non è presente nessun programma.

  Se collegato via USB, il bootloader dell'RP2040 appare al computer come una
  chiavetta USB (mass storage device) e il trasferimento del programma avviene
  attraverso il drag and drop dell'eseguibile.

== Protocollo USB

Il protocollo USB è di tipo master/slave, ovvero host/device. Il PC è l'host,
mentre il dispositivo collegato è il device.

Durante il collegamento si distinguono due fasi:

- Fase di enumerazione: inizialmente viene erogata una corrente massima di
  $100 thick upright(m A)$, in modo da non danneggiare l'host. Il device
  comunica il protocollo da usare e la quantità di corrente necessaria al suo
  funzionamento.
- Fase attiva: se l'host accetta, il dispositivo può arrivare a consumare fino a
  $500 thick upright(m A)$. Se l'assorbimento supera quanto dichiarato, l'host
  può interrompere l'alimentazione.

I sistemi operativi supportano alcuni profili USB che non richiedono driver per
il dispositivo:

- Mass Storage Device: il dispositivo consente il trasferimento di file e appare
  nel computer come una cartella.
- Human Interface Device (HID): il dispositivo appare come una periferica con
  modalità di input predefinite, come tastiera, mouse o joystick, ecc.

La porta USB non è solo un canale per i dati: quando è usata, il
microcontrollore viene anche alimentato, facilitando lo sviluppo dato che al
programmatore basta un computer.

Il protocollo USB funziona a $5 thick upright(V)$, ma molti controllori
funzionano a $3.3 thick upright(V)$ o anche $1.2 thick upright(V)$, quindi
servono circuiti che riducono la tensione.

= Selezione dei componenti della scheda

Nella progettazione di schede elettroniche non si parte mai da zero, ma si parte
da schemi esistenti, trovati in rete o forniti dai produttori e si scelgono le
sezioni rilevanti.

Altri criteri di scelta sono:

- *disponibilità*: il componente deve essere disponibile a catalogo e nei
  magazzini;
- *costo e prestazioni*: bisogna trovare un compromesso tra prestazioni e
  prezzo;
- *montabilità*: il componente deve essere montabile con gli attrezzi
  disponibili (BGA e componenti più piccoli sono più difficili da montare).

== Affidabilità e fatica

La maggior parte dei guasti elettronici è dovuta a problemi di connessione, come
fili che si rompono per piegature ripetute o per saldature interrotte.

Nell'ingegneria meccanica si usa il concetto di *fatica*: un componente
sottoposto a flessioni ripetute si rompe dopo un certo numero di cicli.

I componenti elettronici hanno solitamente un valore MTBF (Mean Time Between
Failures). Per esempio, un pulsante con MTBF di 200 pressioni si guasta, in
media, dopo circa 200 pressioni.

La fatica è indotta anche da cicli termici e vibrazioni.

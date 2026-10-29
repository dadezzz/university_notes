#import "../_templates/starlight.typ" as starlight;

#show: starlight.setup

#metadata((
  description: "Polling e interrupt, eventi sincroni e asincroni, pull-up e pull-down, uscite digitali, PWM, timer, RTC, protocolli UART, SPI, I2C, USB, Ethernet, RAM e flash.",
  lang: "it",
  prev: false,
  title: "Microcontrollori: eventi, GPIO, PWM e bus seriali",
))

= Microcontrollore

Un microcontrollore è un processore a cui sono state aggiunte periferiche
funzionali. Queste periferiche possono essere ingressi/uscite (GPIO), timer,
moduli di comunicazione, convertitori A/D, ecc.

Durante il corso useremo l'RP2040, un microcontrollore a 32 bit con 30 GPIO.

== Gestione degli eventi

Per gestire eventi che accadono mentre la scheda è in funzione si distinguono
due approcci:

- *Polling*: il programma controlla periodicamente se un evento è accaduto. Il
  processore decide quando verificare, ma se un evento è breve o imprevedibile
  può andare perso.
- *Interrupt*: il sensore che rileva l'evento segnala al processore di svolgere
  una specifica funzione. Il processore sospende l'esecuzione del programma
  principale e si occupa delle routine di interrupt, in ordine di priorità.

Gli eventi possono essere *sincroni*, quindi prevedibili perché legati a un
riferimento temporale (ad esempio la fine di un timer), oppure *asincroni*,
quindi imprevedibili.

== Logica e ingressi

Se il piedino di ingresso di un microcontrollore non è collegato a nulla, si
trova in condizione *flottante*, quindi il suo valore è indefinito per il
microcontrollore. Per evitare questo si usa una resistenza di *pull-up*
collegata a VCC ($3.3 thick upright(V)$ o $5 thick upright(V)$) o una resistenza
di *pull-down* che porta il valore a massa.

La logica del software (ad esempio $"pulsante premuto" = 1$) non corrisponde
sempre a quella del circuito. Spesso i pulsanti presentano un livello alto di
tensione quando non sono premuti, in modo da poter condividere lo stesso
terminale di massa.

== Uscite

Un'uscita digitale del microcontrollore può portare il piedino a
$0 thick upright(V)$ o $5 thick upright(V)$ (variabile a seconda
dell'alimentazione).

La corrente erogabile da un pin è molto piccola, tipicamente qualche
milliampere. Per carichi maggiori bisogna usare un *relè*, ovvero una bobina
che, se alimentata dall'uscita del micro, commuta un interruttore per un altro
circuito in grado di supportare correnti maggiori.

== Pulse Width Modulation (PWM)

Una periferica PWM permette di generare un segnale quadro variando il suo duty
cycle, ossia il rapporto tra il tempo in cui il segnale rimane alto e il periodo
totale.

I suoi utilizzi principali sono:

- Regolare la luminosità di un LED: non si può semplicemente abbassare la
  tensione, perché sotto una certa soglia il diodo si spegnerebbe.
- Regolare la velocità di un motore in corrente continua.
- Pilotare motori brushless trifase.

Si possono ricavare informazioni anche da un'onda quadra in ingresso: ad esempio
la larghezza e la distanza tra gli impulsi possono determinare la velocità di
una ruota (sensore Hall).

== Timer e Real Time Clock (RTC)

Un microcontrollore dispone solitamente di diversi timer, utilizzabili per:

- Generare segnali PWM.
- Effettuare misure di tempo.
- Svegliare il dispositivo tramite interrupt dopo un intervallo di tempo.

L'RTC è un timer che mantiene data e ora, spesso con un quarzo esterno a
$32.768 thick upright(k #h(-1pt) "Hz")$.

== Comunicazioni seriali

I protocolli seriali permettono di trasferire informazioni senza dover collegare
decine di fili in parallelo.

I protocolli che vedremo sono:

- *UART*: usata per comunicazioni seriali punto-punto. La versione classica può
  gestire pochi metri di cavo, mentre la RS485 anche centinaia di metri.
- *SPI*: usata per comunicazioni veloci a corto raggio, confinate alla scheda.
- *I2C*: protocollo su due fili che può gestire multipli dispositivi sullo
  stesso bus.
- *USB*: comunicazione seriale asincrona, con ampia compatibilità.
- *Ethernet*: comunicazione full-duplex su 8 fili. Richiede un chip esterno
  oltre al microcontrollore.

== RAM e flash

Nei microcontrollori, le memorie RAM e flash sono solitamente integrate, in modo
da semplificare la progettazione. L'RP2040 supporta una flash esterna.

La memoria flash contiene il programma da eseguire. Non sempre è possibile
salvare dati in maniera permanente a runtime.

#starlight.note([
  In ambito elettronico si usano spesso notazioni compatte per risparmiare
  spazio sugli schemi elettrici. Per esempio, $10000$ diventa $10 K$ e $10500$
  diventa $10 K 5$.
])

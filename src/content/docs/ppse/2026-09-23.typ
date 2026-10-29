#import "@preview/zap:0.6.0"
#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Simboli, reference designator, net e BOM; proprietà e footprint dei componenti, tombstoning e polarizzazione; architettura RP2040, periferiche e watchdog.",
  lang: "it",
  title: "Schemi elettrici, footprint e architettura RP2040",
))

= Schemi elettrici

Il punto di partenza di uno schema elettrico è il simbolo, ovvero un oggetto
grafico che rappresenta un componente (resistore, condensatore, diodo, ecc.).

I simboli e le loro connessioni rappresentano il circuito. Solitamente sul CAD
non si rappresenta tutto sullo stesso foglio: è opportuno suddividere ogni
sottocircuito su varie pagine per aumentare la leggibilità.

Ogni componente della scheda ha un nome univoco (in inglese *reference
designator*, abbreviato *ref des*). Di solito si segue uno standard per
categoria:

- resistori: `R1`, `R2`, ...
- condensatori: `C1`, `C2`, ...
- diodi e LED: `D1`, `D2`, ... (o `DL` in alcuni schemi)
- transistor: `Q1`, `Q2`, ...
- circuiti integrati: `U1`, `U2`, ...

Questi riferimenti si usano anche per redigere il Bill of Materials (BOM), dove
si indica quale componente corrisponde a ciascun riferimento.

Sullo schema è opportuno inserire anche tutte le note di progettazione, così che
raggiungano tutti gli attori coinvolti nell'implementazione e costituiscano
un'unica fonte di verità.

C'è una corrispondenza tra schema e PCB: ciò che è nello schematico deve
trovarsi nel layout fisico. Non è vero il contrario, dato che il progettista può
aggiungere elementi meccanici (fori di montaggio, test point, fiducial) per
facilitare il montaggio e il collaudo.

== Cartiglio e revisioni

Ogni scheda industriale comprende un cartiglio dove si trovano il nome del
progetto, l'autore, la data e la revisione.

Il versionamento può essere basato sulla data di modifica o seguire le
convenzioni usate anche per il software.

== Connessioni elettriche

Una *net* è una connessione elettrica, ovvero tutto ciò che è collegato dallo
stesso filo in maniera fisica o logica (componenti collegati a terra non hanno
lo stesso filo fisico, ma si comportano come se ci fosse).

A ogni net si può dare un nome significativo (es. `V_ALIM`, `GND`) che rende più
comoda la progettazione quando lo schema è suddiviso su più pagine.

== Proprietà di un componente

A ogni componente sono assegnate proprietà che possono essere popolate o meno.
Tre di queste sono obbligatorie:

- reference designator;
- valore (es. $10 thick upright(k Omega)$, $100 thick upright(n F)$,
  $20 thick upright(M #h(-1pt) "Hz")$);
- footprint: impronta fisica sul PCB (es. `0603`, `0805`, `1206`);

Altre proprietà sono opzionali:

- tecnologia di montaggio: Through-Hole (componenti con piedini da inserire) o
  SMD (componenti da saldare sulla superficie);
- tolleranza: per resistori o quarzi;
- potenza dissipabile;
- modello del componente;
- costo unitario, per calcolare il costo totale della scheda.

=== Footprint e dimensioni dei componenti

Il footprint è l'impronta fisica del componente che viene montato sul circuito.

I componenti SMD sono classificati con codici numerici che indicano le
dimensioni in millesimi di pollice: `0402`, `0603`, `0805`, `1206`, `1210`, ecc.

Talvolta i componenti SMD possono essere soggetti a *tombstoning*. Durante la
rifusione (ad esempio se si stanno fissando componenti sull'altro lato della
scheda), se le forze di tensione superficiale dello stagno liquido non sono
bilanciate (per esempio per piazzole di dimensioni diverse o per pasta saldante
distribuita in modo non uniforme), esse possono tirare il componente da un lato
e portarlo in posizione verticale.

#starlight.img("images/tombstoning.png", alt: "Tombstoning")

La dimensione fisica di un componente è legata alla potenza che esso può
dissipare come calore. Un esempio notevole è costituito dalle *resistenze
shunt*, che si usano per misurare la corrente assorbita da un componente
mettendole in serie e applicando la legge di Ohm: $I = V / R_"shunt"$.

=== Polarizzazione

Componenti come i resistori e i condensatori ceramici (quelli SMD marroni) si
comportano allo stesso modo in entrambi i versi della corrente.

Altri, invece, come i diodi e i condensatori elettrolitici, devono essere
posizionati nella direzione corretta, specificata nello schematico.

#starlight.note([
  I condensatori elettrolitici hanno solitamente capacità maggiori di quelle dei
  condensatori ceramici.
])

= RP2040

L'RP2040 è un microcontrollore prodotto da Raspberry Pi. Si basa su
un'architettura ARM Cortex-M0+ dual-core con frequenza di clock di
$133 thick upright(M #h(-1pt) "Hz")$, portabile fino a
$200 thick upright(M #h(-1pt) "Hz")$ tramite overclock.

Dispone di $264 thick upright(k B)$ di RAM. La flash è esterna, accessibile
tramite QSPI con modalità XIP (eXecute In Place): il codice viene eseguito dalla
memoria esterna come se fosse interna.

Il microcontrollore interagisce con l'esterno tramite 30 pin GPIO. Non tutti
sono esposti sulle schede che lo montano: ad esempio, sulla Raspberry Pi Pico ne
sono disponibili 26. Alcuni pin possono essere configurati come input/output di
periferiche specifiche (es. PWM), ma la mappatura non è completamente
arbitraria.

== Periferiche

- USB 1.1 in modalità host e device. Normalmente la scheda si presenta come
  device, ma può fare da host per collegare mouse, tastiere, memorie, ecc.
- ADC: convertitore analogico-digitale a 4 canali con risoluzione di 12 bit.
- PWM
- SPI e I2C
- UART
- Timer e RTC
- Reset e watchdog

L'RP2040 contiene dei blocchi PIO (Programmable I/O), ovvero delle macchine a
stati programmabili che possono eseguire compiti autonomi, indipendentemente
dalla CPU. È un concetto simile a quello delle FPGA, ma più limitato.

=== Watchdog

Il watchdog è un timer indipendente che deve essere esplicitamente azzerato dal
software prima che scada.

Se il programma si blocca in un loop infinito o in un deadlock, il watchdog
scade e solitamente provoca un reset del microcontrollore.

È utile per recuperare da errori o situazioni impreviste, ma va usato con
cautela in applicazioni critiche, dove un riavvio potrebbe essere pericoloso
(es. ABS di un'automobile).

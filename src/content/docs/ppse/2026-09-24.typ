#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Protezioni di alimentazione con diodi, fusibili, TVS, sparkgap e condensatori, modello reale della batteria e regolatori di tensione lineari e switching.",
  lang: "it",
  title: "Alimentazione: protezioni, batterie e regolatori",
))

= Alimentazione

Una sezione fondamentale di ogni schema elettrico è quella dedicata
all'alimentazione. Può essere molto semplice (un connettore per batteria o jack
di alimentazione) o più complessa (con protezioni e cambi di tensione).

Uno stadio di alimentazione complesso può avere:

- *Diodi*: per proteggere dall'inversione di polarità. Un diodo conduce solo in
  una direzione, quindi previene danni se si inserisce la batteria al contrario
  o si usa un alimentatore con polarità sbagliata.
- *Fusibili*: un sottile filo conduttore che si fonde per evitare eccessi di
  corrente. Possono essere quelli classici, che si bruciano e vanno sostituiti,
  o quelli moderni ai polimeri, che si ripristinano una volta che la corrente
  torna normale.
- *TVS* (Transient Voltage Suppressor): dispositivo a due terminali che protegge
  dalle sovratensioni. Se la tensione supera quella attesa, il TVS cortocircuita
  e assorbe l'energia in eccesso scaldandosi.
- *Sparkgap*: due punte ravvicinate che conducono solo in caso di altissima
  tensione. Sono più lenti di un TVS, ma possono sopportare correnti molto più
  elevate.
- *Condensatori*: proteggono dai cali di tensione. Il condensatore immagazzina
  energia e la rilascia nel caso in cui la fonte di alimentazione non fornisca
  corrente per un breve periodo di tempo.

#starlight.note([
  Nei circuiti si usano più condensatori in parallelo invece di uno grande per
  ridurre l'effetto della resistenza serie intrinseca (ESR): come per le
  resistenze in parallelo, l'effetto complessivo si riduce.
])

#starlight.caution([
  I condensatori possono rimanere carichi per un tempo indefinito. Talvolta si
  aggiunge una resistenza molto grande in parallelo per questioni di sicurezza.
])

== Batteria

Una batteria non è un generatore di tensione ideale. Il modello reale include:

- Una resistenza interna in serie che aumenta con l'invecchiamento.
- Una resistenza in parallelo (autoscarica).
- Un limite alla potenza erogabile.

== Regolatori di tensione

I regolatori di tensione si dividono in due categorie principali: lineari e
switching. A seconda della tensione di uscita rispetto a quella di ingresso, si
distinguono inoltre:

- *step-down* (buck): abbassano la tensione;
- *step-up* (boost): alzano la tensione, utili per sfruttare meglio batterie
  scariche.

=== Regolatori lineari (LDO)

Il tipo di regolatore più semplice è il lineare, che funziona come una
resistenza variabile in serie e mantiene la tensione costante introducendo una
caduta.

Il modo in cui avviene la conversione è per dissipazione di potenza (in calore).
Gli step-down più famosi so quelli della serie 78xx (es. ts7805), che sono
composti da un corpo di metallo e un'area dove agganciare un heatsink.

La potenza dissipata è $P = V_"drop" I$. Questo tipo di regolatore non è adatto
ad applicazioni a batteria, data la scarsa efficienza. Normalmente si usa in
situazioni in cui bisogna minimizzare i costi.

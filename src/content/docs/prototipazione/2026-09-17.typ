#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Protezione dell'alimentazione con diodi, fusibili, transil, sparkgap e condensatori, più regolazione di tensione tramite LDO e convertitori buck e boost.",
  lang: "it",
  prev: false,
  title: "Stadi di alimentazione e regolazione di tensione",
))

= Alimentazione

Uno stadio di alimentazione complesso può avere:

- Diodi per proteggere da inversione di polarità.
- Fusibili per evitare eccessi di corrente. Possono essere quelli classici che
  si bruciano e vanno sostituiti, o quelli moderni a polimeri che si
  ripristinano una volta che la corrente torna normale.
- Transil/Transzorb per cortocircuitare quando la tensione eccede quella attesa,
  mantenendo il massimo stabilito fino a bruciarsi.
- Sparkgap per scaricare eccessi di tensione, più veloci dei Transil/Transzorb.
- Condensatori che proteggono da cali di tensione. Il condensatore immagazzina
  energia e la rilascia nel caso in cui la fonte di alimentazione non fornisca
  corrente per un breve periodo di tempo.


#starlight.note([
  Nei circuiti si usano più condensatori in parallelo invece di uno grande per
  ridurre l'effetto dato dalla resistenza in serie intrinseca.

  Infatti, collegare resistenze in parallelo riduce il loro effetto totale.
])

#starlight.warn([
  I condensatori possono rimanere carichi per un tempo indefinito. Talvolta si
  aggiunge una resistenza molto grande in parallelo per questioni di sicurezza.
])

== Regolazione della tensione

I microcontrollori lavorano solitamente a 5 V o 3,3 V. Tuttavia, i core interni
lavorano a 1,1 V. L'LDO trasforma la tensione in ingresso in quella desiderata.

Più in generale, servono dei circuiti che regolano la tensione, portandola a
quella desiderata:

- step-up (boost): alzano la tensione;
- step-down (buck): abbassano la tensione;

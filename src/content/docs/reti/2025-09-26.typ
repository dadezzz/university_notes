#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "I quattro componenti del ritardo di rete (elaborazione, accodamento, trasmissione e propagazione), la loro somma nel ritardo di nodo e il programma traceroute.",
  lang: "it",
  title: "Ritardi di rete, ritardo di nodo e traceroute",
))


= Ritardi e perdite

Ci sono 4 elementi che possono introdurre un ritardo nella rete:

- *ritardo di elaborazione del nodo*:
  - controllo degli errori sui bit;
  - determinazione della porta o del canale di uscita;
- *ritardo di accodamento*:
  - attesa di trasmissione del pacchetto;
  - livello di congestione del router;
- *ritardo di trasmissione (L/R)*: rapporto tra la lunghezza del pacchetto e il
  bitrate;
- *ritardo di propagazione (d/s)*: rapporto tra la lunghezza del collegamento
  fisico e la velocità di propagazione sul collegamento;

La somma di tutti questi ritardi viene detta ritardo di nodo.

= Traceroute

È un programma diagnostico che fornisce una misura del ritardo tra la sorgente e
ciascun router lungo il percorso verso la destinazione su Internet.

- invia 3 pacchetti per ogni router lungo il percorso;
- i router risponderanno, rivelando a volte la loro identità;
- il mittente calcola l'intervallo tra trasmissione e risposta;

Se ci sono 3 `* * *`, significa che il pacchetto è stato perso o che il router
non ha risposto.

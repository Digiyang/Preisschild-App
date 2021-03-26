class Category {
  final String link;
  final String title;
  final String details;
  final int color;

  Category({this.link, this.title, this.details, this.color});
}

final categories = <Category>[
  Category(
    title: "Bread",
    details:
        "Unsere Brote und Brötchen backen wir fast ausschließlich aus dem ganzen Korn"
        "welches  wir selbst zu Schrot und Vollkornmehl vermahlen. Die weiße Schrippe wird man daher bei uns vergeblich suchen."
        "Gemahlen wird auf drei Natursteinmühlen aus den Sextener Dolomiten, die mit ihrer langsamen Gangart das Korns schonend aufschließlich."
        "So bleiben all Vitamine, Nähr-und Minertalstoffe des guten Demetergetreides erhalten."
        "Aus Überzeugung verwenden wir als Rohstoff ausschließlich DEMETER-Getreide aus biologisch-dynamischer Landwirtschaft."
        "Diese Landwirte arbeiten in respektvollem Verhältnis zu Natur und Mensch vereint mit einem umfassenden Verständnis von Boden, Jahreszeiten und Umwelt."
        "Der Anbau folgt den Zyklen der Natur und den strengsten Regeln aller Bio-Anbauverbände."
        "Das Wasser für unser Brot strömt vor der Verarbeitung durch eine spezielle Vorrichtung aus Halbedelsteinen, die ihm eine ursprüngliche Vitalität, ähnlich der von Quellwasser, verleihen."
        " Mit diesem Wasser konnten wir eine deutlich verbesserte Aktivität der Gärung feststellen."
        "Als Triebmittel verwenden wir hauptsächlich Backferment, eine Art Sauerteig, bei dem die Gärung auf Milchsäurebakterien und nicht wie beim klassischen Sauerteig auf Essigsäurebakterien beruht."
        " Die Brote sind dadurch besonders fein im Geschmack und sehr gut bekömmlich. Wir sind seit unserer ersten Stunde mit Backferment bestens vertraut und verwenden in der ganzen Bäckerei keinen klassischen Sauerteig, da dieser das empfindliche Ferment beeinträchtigen würde."
        "Und schließlich das Salz: es handelt sich um reines, unjodiertes Meersalz, das mild im Geschmack ist."
        " Wir salzen unsere Brote eher schwach, nur gerade so, dass sich ein optimales Aroma entfaltet.\n"
        "In unserem Betrieb verwenden wir weder fertige Bio-Backmischungen, noch irgendeine andere Art chemisch-industrieller Backhilfsmittel.\n",
    link: "assets/images/icons8-bread-100.png",
    color: 0xFF238BD0,
  ),
  Category(
    title: "Birthday Cake",
    details: "Here you can find all sorts of Birthday Cakes",
    link: "assets/images/icons8-birthday-cake-100.png",
    color: 0xFFE83835,
  ),
  Category(
    title: "Croissant",
    details: "Here you can find all sorts of Croissant",
    link: "assets/images/icons8-croissant-100.png",
    color: 0xFF354C6C,
  ),
  Category(
    title: "Pie",
    details: "Here you can find all sorts of Pie",
    link: "assets/images/icons8-pie-100.png",
    color: 0xFF6F2B62,
  ),
  Category(
    title: "Macaron",
    details: "Here you can find all sorts of Macaron",
    link: "assets/images/icons8-macaron-100.png",
    color: 0xFFBD9158,
  )
];

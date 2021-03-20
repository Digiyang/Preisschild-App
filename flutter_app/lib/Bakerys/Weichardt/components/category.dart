class Category {
  final String link;
  final String title;
  final String details;
  final int color;

  Category({
    this.link,
    this.title,
    this.details,
    this.color
  });
}

final categories = <Category>[
  Category(
    title: "Bread",
    details: "Here you can find all sorts of Bread",
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
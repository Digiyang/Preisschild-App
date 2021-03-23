class WeichProduct {
  const WeichProduct({
    this.name,
    this.description,
    this.price,
    this.weight,
    this.picture,
  });
  final String name, description, picture, weight;
  final double price;
}

const weichProducts = <WeichProduct>[
  WeichProduct(
      name: "Bagel",
      description: "this a",
      price: 3.49,
      weight: "500g",
      picture: "assets/Weich/icons8-bagel-100.png"),
  WeichProduct(
      name: "Baguette",
      description: "this a",
      price: 2.39,
      weight: "500g",
      picture: "assets/Weich/icons8-baguette-bread-100.png"),
  WeichProduct(
      name: "Bread",
      description: "this a",
      price: 1.49,
      weight: "500g",
      picture: "assets/Weich/icons8-bread-100.png"),
  WeichProduct(
      name: "Bread loaf",
      description: "this is a",
      price: 1.40,
      weight: "500g",
      picture: "assets/Weich/icons8-bread-loaf-100.png"),
  WeichProduct(
      name: "Hamburger",
      description: "this a",
      price: 3.00,
      weight: "500g",
      picture: "assets/Weich/icons8-hamburger-100.png"),
  WeichProduct(
      name: "Naan",
      description: "this a",
      price: 2.69,
      weight: "500g",
      picture: "assets/Weich/icons8-naan-100.png"),
  WeichProduct(
      name: "Pretzel",
      description: "this a",
      price: 1.20,
      weight: "500g",
      picture: "assets/Weich/icons8-pretzel-100.png"),
  WeichProduct(
      name: "Sandwich",
      description: "Sandwich",
      price: 4.50,
      weight: "500g",
      picture: "assets/Weich/icons8-sandwich-100.png"),
];

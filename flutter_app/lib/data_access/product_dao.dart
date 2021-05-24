class ProductDao {
  int id;
  String title;
  String edited_title;
  String brand;
  double weight; // in gm
  double unit_price;
  int quantity;
  String category;
  String description;
  String short_description;
  String image_url;

  ProductDao(int id, String title,
            String brand, double weight,
            double unit_price, int quantity,
            String category, String description,
            String short_description, String image_url) {

      this.id = id;
      this.title = title;
      this.brand = brand;
      this.weight = weight;
      this.unit_price = unit_price;
      this.quantity = quantity;
      this.category = category;
      this.description = description;
      this.short_description = short_description;
      this.image_url = image_url;
  }

  int get productId {
    return id;
  }

  String get productTitle {
    return title;
  }

  set productTitle(String title) {
    this.title = title;
  }

  String get productEditedTitle {
    return edited_title;
  }

  set productEditedTitle(String edited_title) {
    this.edited_title = edited_title;
  }

  String get productBrand {
    return brand;
  }

  double get productWeight {
    return weight;
  }

  double get unitPrice {
    return unit_price;
  }

  int get productQuantity {
    return quantity;
  }

  String get productCategory {
    return category;
  }

  String get productDescription {
    return description;
  }

  String get productShortDescription {
    return short_description;
  }

  String get productImageUrl {
    return image_url;
  }

  static List<ProductDao> convert(String v) {
    List<String> lines = v.split("\n");
    List<ProductDao> products = [];

    for (String l in lines) {
      if (l.contains("|")) {

        if (l.contains("id")) {
          continue;
        }

        List<String> values = l.split("|");
        products.add(ProductDao(int.parse(values[1].trim()),
                                values[2].trim(),
                                values[3].trim(),
                                double.parse(values[4].trim()),
                                double.parse(values[5].trim()),
                                int.parse(values[6].trim()),
                                values[7].trim(),
                                values[8].trim(),
                                values[9].trim(),
                                values[10].trim()));
      }
    }

    return products;
  }

  static List<String> convertCategory(String v) {
    List<String> lines = v.split("\n");
    List<String> categories = [];

    for (String l in lines) {
      if (l.contains("|")) {

        if (l.contains("category")) {
          continue;
        }

        List<String> values = l.split("|");
        categories.add(values[1].trim());
      }
    }

    return categories;
  }
}
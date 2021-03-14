class OrderDao {
  String order_id;
  DateTime order_date;
  double total_price;
  String order_status;
  String item_name;
  int item_quantity;
  String item_price;

  OrderDao(String order_id,
            DateTime order_date,
            double total_price,
            String order_status,
            String item_name,
            int item_quantity,
            String item_price) {

    this.order_id = order_id;
    this.order_date = order_date;
    this.total_price = total_price;
    this.order_status = order_status;
    this.item_name = item_name;
    this.item_quantity = item_quantity;
    this.item_price = item_price;
  }

  String get orderId {
    return order_id;
  }

  DateTime get orderDate {
    return order_date;
  }

  double get totalPrice {
    return total_price;
  }

  String get orderStatus {
    return order_status;
  }

  String get itemName {
    return item_name;
  }

  int get itemQuantity {
    return item_quantity;
  }

  String get formattedItemPrice {
    return item_price;
  }

  double get itemPrice {
    return double.parse(item_price.split("=").last.trim());
  }

  static List<OrderDao> convert(String v) {
    List<String> lines = v.split("\n");
    List<OrderDao> order_details = [];

    for (String l in lines) {
      if (l.contains("|")) {

        if (l.contains("order_id")) {
          continue;
        }

        List<String> values = l.split("|");
        order_details.add(OrderDao(values[1].trim(),
                                    DateTime.parse(values[2].trim()),
                                    double.parse(values[3].trim()),
                                    values[4].trim(),
                                    values[5].trim(),
                                    int.parse(values[6].trim()),
                                    values[7].trim()));
      }
    }

    return order_details;
  }
}
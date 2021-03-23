import 'package:flutter_app/data_access/product_dao.dart';

class OrderItemDao {
  double itemPrice;
  int quantity;
  ProductDao product;

  OrderItemDao(double itemPrice, int quantity) {
    this.itemPrice = itemPrice;
    this.quantity = quantity;
  }

  String get itemName {
    return product.title;
  }

  int get itemQuantity {
    return quantity;
  }

  String get formattedItemPrice {
    return "$quantity x " + product.unitPrice.toString() + " = " + itemPrice.toString();
  }

  double get itmPrice {
    return itemPrice;
  }

  ProductDao get itemProduct {
    return itemProduct;
  }

  void set itemProduct(ProductDao prd) {
    this.product = prd;
  }

  static List<OrderItemDao> convert(String v) {
    List<String> lines = v.split("\n");
    List<OrderItemDao> orderItem_details = [];

    for (String l in lines) {
      if (l.contains("|")) {

        if (l.contains("id")) {
          continue;
        }

        List<String> values = l.split("|");
        orderItem_details.add(OrderItemDao(double.parse(values[1].trim()), int.parse(values[2].trim())));
      }
    }

    return orderItem_details;
  }
}
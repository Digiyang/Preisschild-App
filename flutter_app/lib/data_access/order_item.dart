class OrderItem {
  int product_id;
  double unit_price;
  int quantity;

  OrderItem(int product_id, int quantity) {
    this.product_id = product_id;
    this.quantity = quantity;
  }

  int get productId {
    return product_id;
  }

  int get itemQuantity {
    return quantity;
  }

  set unitPrice(double unit_price) {
    this.unit_price = unit_price;
  }

  double get unitPrice {
    return unit_price;
  }
}
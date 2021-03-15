class OrderItem {
  int product_id;
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
}
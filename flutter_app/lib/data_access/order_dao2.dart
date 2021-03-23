import 'order_item_dao.dart';

class OrderDao {
  String orderId;
  DateTime date;
  double price;
  String orderStatus;
  DateTime createdDate;
  DateTime modifiedDate;
  List<OrderItemDao> orderItems;

  OrderDao(String orderId, DateTime date,
            double price, String orderStatus,
            DateTime createdDate, DateTime modifiedDate) {

    this.orderId = orderId;
    this.date = date;
    this.price = price;
    this.orderStatus = orderStatus;
    this.createdDate = createdDate;
    this.modifiedDate = modifiedDate;
    this.orderItems = [];
  }

  String get orderID {
    return orderId;
  }

  DateTime get orderDate {
    return date;
  }

  double get orderPrice {
    return price;
  }

  String get status {
    return orderStatus;
  }

  DateTime get creationDate {
    return createdDate;
  }

  DateTime get modifyDate {
    return modifiedDate;
  }

  List<OrderItemDao> get items {
    return orderItems;
  }

  void set items(List<OrderItemDao> ordItems) {
    this.orderItems.addAll(ordItems);
  }

  static List<OrderDao> convert(String v) {
    List<String> lines = v.split("\n");
    List<OrderDao> order_details = [];

    for (String l in lines) {
      if (l.contains("|")) {

        if (l.contains("id")) {
          continue;
        }

        List<String> values = l.split("|");
        order_details.add(OrderDao(values[2].trim(),
                                    DateTime.parse(values[3].trim()),
                                    double.parse(values[4].trim()),
                                    values[5].trim(),
                                    DateTime.parse(values[6].trim()),
                                    DateTime.parse(values[7].trim())));
      }
    }

    return order_details;
  }
}
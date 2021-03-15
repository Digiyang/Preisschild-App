import 'package:flutter_app/data_access/order_dao.dart';
import 'package:flutter_app/Services/order_service.dart';
import 'package:flutter_app/data_access/order_item.dart';

class OrderBL {

  final OrderService service = OrderService();

  //TODO try to make generic bl functions
  Future<List<OrderDao>> get_all_orders() async {
    List<OrderDao> details = await service.get_all_orders();
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_id(String orderId) async {
    List<OrderDao> details = await service.get_orders_by_id(orderId);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_date(DateTime date) async {
    List<OrderDao> details = await service.get_orders_by_date(date);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_date_range(DateTime begin, DateTime end) async {
    List<OrderDao> details = await service.get_orders_by_date_range(begin, end);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_status(String status) async {
    List<OrderDao> details = await service.get_orders_by_status(status);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_status_and_date(String status, DateTime date) async {
    List<OrderDao> details = await service.get_orders_by_status_and_date(status, date);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_status_and_date_range(String status, DateTime begin, DateTime end) async {
    List<OrderDao> details = await service.get_orders_by_status_and_date_range(status, begin, end);
    return Future.value(details);
  }

  Future<void> create_order(String orderId) async {
    await service.create_order(orderId);
  }

  Future<void> create_order_item(String orderId, int productId, int quantity) async {
    await service.create_order_item(orderId, productId, quantity);
  }

  Future<void> create_order_with_items(String orderId, List<OrderItem> items) async {
    await service.create_order_with_items(orderId, items);
  }

  Future<void> update_order_status(String orderId) async {
    await service.update_order_status(orderId);
  }

}

void main() async {
  List<OrderDao> details = await OrderBL().get_all_orders();
  // List<OrderDao> details = await OrderBL().get_orders_by_id("cd123456");
  // List<OrderDao> details = await OrderBL().get_orders_by_date(DateTime.parse("2021-03-05"));
  // List<OrderDao> details = await OrderBL().get_orders_by_status("RECEIVE");
  // List<OrderDao> details = await OrderBL().get_orders_by_status_and_date("RECEIVE", DateTime.parse("2021-03-05"));

  // OrderBL orderBL = OrderBL();
  //
  // String orderId = "op123456";
  // List<OrderItem> items = [OrderItem(1, 2), OrderItem(2, 2)];

  // await orderBL.create_order_with_items(orderId, items);
  // List<OrderDao> details = await orderBL.get_orders_by_id(orderId);

  // List<OrderDao> details = await orderBL.get_orders_by_date(DateTime.now());
  // List<OrderDao> details = await orderBL.get_orders_by_status("CONFIRM");

  // await orderBL.update_order_status(orderId);
  // List<OrderDao> details = await orderBL.get_orders_by_status("RECEIVE");

  print("Resultset length: " + details.length.toString());
  print("------------------------------------------");

  for (OrderDao o in details) {
    print(o.orderId);
    print(o.orderDate);
    print(o.orderStatus);
    print(o.totalPrice);
    print(o.itemName);
    print(o.itemQuantity);
    print(o.formattedItemPrice);
    print("------------------------------------------");
  }
}
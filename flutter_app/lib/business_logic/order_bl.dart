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

  Future<List<OrderDao>> get_orders_by_date(int organizationId, DateTime date) async {
    List<OrderDao> details = await service.get_orders_by_date(organizationId, date);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_date_range(int organizationId, DateTime begin, DateTime end) async {
    List<OrderDao> details = await service.get_orders_by_date_range(organizationId, begin, end);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_status(int organizationId, String status) async {
    List<OrderDao> details = await service.get_orders_by_status(organizationId, status);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_status_and_date(int organizationId, String status, DateTime date) async {
    List<OrderDao> details = await service.get_orders_by_status_and_date(organizationId, status, date);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_status_and_date_range(int organizationId, String status, DateTime begin, DateTime end) async {
    List<OrderDao> details = await service.get_orders_by_status_and_date_range(organizationId, status, begin, end);
    return Future.value(details);
  }

  Future<void> create_order(int organizationId, String orderId) async {
    await service.create_order(organizationId, orderId);
  }

  Future<void> create_order_item(String orderId, int productId, int quantity) async {
    await service.create_order_item(orderId, productId, quantity);
  }

  Future<void> create_order_with_items(int organizationId, String orderId, List<OrderItem> items) async {
    await service.create_order_with_items(organizationId, orderId, items);
  }

  Future<void> update_order_status(String orderId) async {
    await service.update_order_status(orderId);
  }

}

void main() async {
  // List<OrderDao> details = await OrderBL().get_all_orders();
  // List<OrderDao> details = await OrderBL().get_orders_by_id("cd123456");
  // List<OrderDao> details = await OrderBL().get_orders_by_date(1, DateTime.parse("2021-03-05"));
  // List<OrderDao> details = await OrderBL().get_orders_by_status(1, "RECEIVE");
  // List<OrderDao> details = await OrderBL().get_orders_by_status_and_date(1, "RECEIVE", DateTime.parse("2021-03-05"));

  OrderBL orderBL = OrderBL();

  String orderId = "ef666622";
  List<OrderItem> items = [OrderItem(1, 2), OrderItem(2, 2)];

  await orderBL.create_order_with_items(1, orderId, items);
  List<OrderDao> details = await orderBL.get_orders_by_id(orderId);

  // List<OrderDao> details = await orderBL.get_orders_by_date(1, DateTime.now());
  // List<OrderDao> details = await orderBL.get_orders_by_status(1, "CONFIRM");

  // await orderBL.update_order_status(orderId);
  // List<OrderDao> details = await orderBL.get_orders_by_status(1, "RECEIVE");

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
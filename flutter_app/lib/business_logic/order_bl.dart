import 'package:flutter_app/data_access/order_dao.dart';
import 'package:flutter_app/Services/order_service.dart';

class OrderBL {

  final OrderService service = OrderService();

  Future<List<OrderDao>> get_order_details(String orderId) async {
    List<OrderDao> details = await service.get_order_details(orderId);
    return Future.value(details);
  }

}

void main() async {
  List<OrderDao> details = await OrderBL().get_order_details("orderId");
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
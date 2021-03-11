import 'package:flutter_app/data_access/order_dao.dart';
import 'package:flutter_app/Services/order_service.dart';

class OrderBL {

  final OrderService service = OrderService();

  List<OrderDao> get_order_details() {
  // List<OrderDao> get_order_details() async {
    // await service.get_order_details("order_id", (List<OrderDao> details) {
    //
    // });
    return List.empty();
  }
}
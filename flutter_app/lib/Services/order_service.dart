import 'package:flutter_app/data_access/db_connector.dart';

import '../data_access/order_dao.dart';

typedef OrderResponseCallback = void Function(List<OrderDao> details);

class OrderService {

  final DBConnector connector = DBConnector();

  void get_order_details(String order_id, OrderResponseCallback response) async {

    var query = "SELECT ord.order_id, " +
                        "ord.date as order_date, " +
                        "ord.price as total_price, " +
                        "ord.order_status, " +
                        "prd.title as item_name, " +
                        "ord_itm.quantity as item_quantity, " +
                        "CONCAT(ord_itm.quantity, ' x ', prd.unit_price, ' = ', ord_itm.item_price) as item_price " +
                "FROM Preisschild.tbl_order_item as ord_itm, " +
                      "Preisschild.tbl_order as ord, " +
                      "Preisschild.tbl_product as prd " +
                "WHERE ord_itm.order_id = ord.id " +
                "AND	ord_itm.product_id = prd.id;";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) => response(OrderDao.convert(v)));
  }
}
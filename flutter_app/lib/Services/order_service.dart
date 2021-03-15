import 'dart:async';

import 'package:flutter_app/data_access/db_connector.dart';
import 'package:flutter_app/data_access/order_dao.dart';
import 'package:flutter_app/data_access/order_item.dart';

class OrderService {

  static final String baseQuery = "SELECT ord.order_id, " +
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
                                  "AND ord_itm.product_id = prd.id";

  final DBConnector connector = DBConnector();
  StreamController<OrderDao> orderStream = StreamController();

  // TODO try to make generic service function
  // TODO make generic function in connector class
  Future<List<OrderDao>> get_all_orders() async {

    var query = baseQuery;

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        orderStream.close();
      }

      List<OrderDao> details = OrderDao.convert(v);

      if (details.length > 0) {
        for (OrderDao od in details) {
          orderStream.add(od);
        }
      }
    });

    List<OrderDao> details = [];
    await for (OrderDao o in orderStream.stream) {
      details.add(o);
    }

    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_id(String orderId) async {

    var query = baseQuery + " AND ord.order_id = '$orderId'";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        orderStream.close();
      }

      List<OrderDao> details = OrderDao.convert(v);

      if (details.length > 0) {
        for (OrderDao od in details) {
          orderStream.add(od);
        }
      }
    });

    List<OrderDao> details = [];
    await for (OrderDao o in orderStream.stream) {
      details.add(o);
    }

    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_date(DateTime date) async {

    String str_date = date.year.toString() + "-" +
                    (date.month < 10 ? ("0" + date.month.toString()) : date.month.toString()) + "-" +
                    (date.day < 10 ? ("0" + date.day.toString()) : date.day.toString());

    DateTime begin = DateTime.parse("$str_date 00:00:00");
    DateTime end = DateTime.parse("$str_date 23:59:59");

    return get_orders_by_date_range(begin, end);
  }

  Future<List<OrderDao>> get_orders_by_date_range(DateTime begin, DateTime end) async {

    var query = baseQuery +
                " AND ord.date >= '$begin' " +
                " AND ord.date <= '$end'";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        orderStream.close();
      }

      List<OrderDao> details = OrderDao.convert(v);

      if (details.length > 0) {
        for (OrderDao od in details) {
          orderStream.add(od);
        }
      }
    });

    List<OrderDao> details = [];
    await for (OrderDao o in orderStream.stream) {
      details.add(o);
    }

    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_status(String status) async {
    var query = baseQuery + " AND ord.order_status = '$status'";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        orderStream.close();
      }

      List<OrderDao> details = OrderDao.convert(v);

      if (details.length > 0) {
        for (OrderDao od in details) {
          orderStream.add(od);
        }
      }
    });

    List<OrderDao> details = [];
    await for (OrderDao o in orderStream.stream) {
      details.add(o);
    }

    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_status_and_date(String status, DateTime date) async {

    String str_date = date.year.toString() + "-" +
                      (date.month < 10 ? ("0" + date.month.toString()) : date.month.toString()) + "-" +
                      (date.day < 10 ? ("0" + date.day.toString()) : date.day.toString());

    DateTime begin = DateTime.parse("$str_date 00:00:00");
    DateTime end = DateTime.parse("$str_date 23:59:59");

    return get_orders_by_status_and_date_range(status, begin, end);
  }

  Future<List<OrderDao>> get_orders_by_status_and_date_range(String status, DateTime begin, DateTime end) async {
    var query = baseQuery +
                " AND ord.order_status = '$status' " +
                " AND ord.date >= '$begin' " +
                " AND ord.date <= '$end'";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        orderStream.close();
      }

      List<OrderDao> details = OrderDao.convert(v);

      if (details.length > 0) {
        for (OrderDao od in details) {
          orderStream.add(od);
        }
      }
    });

    List<OrderDao> details = [];
    await for (OrderDao o in orderStream.stream) {
      details.add(o);
    }

    return Future.value(details);
  }

  Future<void> create_order(String orderId) async {
    var query = "INSERT INTO Preisschild.tbl_order(order_id, date) VALUES ('$orderId', CURRENT_TIMESTAMP)";
    var exitcode = await connector.execute_through_ssh(query, (_ , v) {});
  }

  Future<void> create_order_item(String orderId, int productId, int quantity) async {
    var query = "CALL create_order_item('$orderId', $productId, $quantity)";
    var exitcode = await connector.execute_through_ssh(query, (_ , v) {});
  }

  Future<void> create_order_with_items(String orderId, List<OrderItem> items) async {
    var query = "INSERT INTO Preisschild.tbl_order(order_id, date) VALUES ('$orderId', CURRENT_TIMESTAMP); ";
    StringBuffer itemQuries = StringBuffer();

    for (OrderItem oi in items) {
      int productId = oi.productId;
      int quantity = oi.itemQuantity;
      itemQuries.write("CALL create_order_item('$orderId', $productId, $quantity); ");
    }

    query = query + itemQuries.toString();
    var exitcode = await connector.execute_through_ssh(query, (_ , v) {});
  }

  Future<void> update_order_status(String orderId) async {
    var query = "UPDATE Preisschild.tbl_order as ord " +
        " SET ord.order_status = 'RECEIVE', " +
        " ord.modified_date = CURRENT_TIMESTAMP " +
        " WHERE ord.order_id = '$orderId'";
    var exitcode = await connector.execute_through_ssh(query, (_ , v) {});
  }

}
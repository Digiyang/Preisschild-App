import 'dart:async';

import 'package:flutter_app/data_access/db_connector.dart';
import 'package:flutter_app/data_access/order_dao.dart';
import 'package:flutter_app/data_access/order_item.dart';
import 'package:mysql1/mysql1.dart';

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
                                  "AND ord_itm.product_id = prd.id ";

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

    // Open a connection
    final conn = await MySqlConnection.connect(ConnectionSettings(host: 'db-preisschild.cygfsaorvowd.eu-central-1.rds.amazonaws.com',
        port: 3306,
        user: 'admin_mahbubur',
        password: 'Dark_Fantasy_2021',
        db: 'Preisschild'));

    // var query = baseQuery + " AND ord.order_id = '$orderId'";
    var query = baseQuery + " AND ord.order_id = ?";

    // var exitcode = await connector.execute_through_ssh(query, (_ , v) {
    //   if (v.trim() == "logout") {
    //     orderStream.close();
    //   }
    //
    //   List<OrderDao> details = OrderDao.convert(v);
    //
    //   if (details.length > 0) {
    //     for (OrderDao od in details) {
    //       orderStream.add(od);
    //     }
    //   }
    // });
    //
    // List<OrderDao> details = [];
    // await for (OrderDao o in orderStream.stream) {
    //   details.add(o);
    // }

    var result = await conn.query(query, [orderId]);

    List<OrderDao> details = [];

    print("get_orders_by_id ($orderId) => " + result.length.toString());

    if (result.isNotEmpty) {
      for (ResultRow r in result) {
        // ToDo update order dao with id attribute and also fix order dao attributes
        details.add(OrderDao(r.fields["order_id"], r.fields["order_date"],
                              r.fields["total_price"], r.fields["order_status"],
                              r.fields["item_name"], r.fields["item_quantity"],
                              r.fields["item_price"]));
      }
    }

    // Finally, close the connection
    await conn.close();

    return Future.value(details);
  }

  Future<List<OrderDao>> get_orders_by_date(int organizationId, DateTime date) async {

    String str_date = date.year.toString() + "-" +
                    (date.month < 10 ? ("0" + date.month.toString()) : date.month.toString()) + "-" +
                    (date.day < 10 ? ("0" + date.day.toString()) : date.day.toString());

    DateTime begin = DateTime.parse("$str_date 00:00:00");
    DateTime end = DateTime.parse("$str_date 23:59:59");

    return get_orders_by_date_range(organizationId, begin, end);
  }

  Future<List<OrderDao>> get_orders_by_date_range(int organizationId, DateTime begin, DateTime end) async {

    var query = baseQuery +
                " AND ord.organization_id = $organizationId " +
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

  Future<List<OrderDao>> get_orders_by_status(int organizationId, String status) async {
    var query = baseQuery + " AND ord.organization_id = $organizationId AND ord.order_status = '$status'";

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

  Future<List<OrderDao>> get_orders_by_status_and_date(int organizationId, String status, DateTime date) async {

    String str_date = date.year.toString() + "-" +
                      (date.month < 10 ? ("0" + date.month.toString()) : date.month.toString()) + "-" +
                      (date.day < 10 ? ("0" + date.day.toString()) : date.day.toString());

    DateTime begin = DateTime.parse("$str_date 00:00:00");
    DateTime end = DateTime.parse("$str_date 23:59:59");

    return get_orders_by_status_and_date_range(organizationId, status, begin, end);
  }

  Future<List<OrderDao>> get_orders_by_status_and_date_range(int organizationId, String status, DateTime begin, DateTime end) async {
    var query = baseQuery +
                " AND ord.organization_id = $organizationId " +
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

  Future<void> create_order(int organizationId, String orderId) async {
    var query = "INSERT INTO Preisschild.tbl_order(organization_id, order_id, date) VALUES ($organizationId, '$orderId', CURRENT_TIMESTAMP)";
    var exitcode = await connector.execute_through_ssh(query, (_ , v) {});
  }

  Future<void> create_order_item(String orderId, int productId, int quantity) async {
    var query = "CALL create_order_item('$orderId', $productId, $quantity)";
    var exitcode = await connector.execute_through_ssh(query, (_ , v) {});
  }

  Future<void> create_order_with_items(int organizationId, String orderId, List<OrderItem> items) async {
    // Open a connection
    final conn = await MySqlConnection.connect(ConnectionSettings(host: 'db-preisschild.cygfsaorvowd.eu-central-1.rds.amazonaws.com',
        port: 3306,
        user: 'admin_mahbubur',
        password: 'Dark_Fantasy_2021',
        db: 'Preisschild'));

    // var query = "INSERT INTO Preisschild.tbl_order(organization_id, order_id, date) VALUES ($organizationId, '$orderId', CURRENT_TIMESTAMP)";
    var query = "INSERT INTO Preisschild.tbl_order(organization_id, order_id, date) VALUES (?, ?, CURRENT_TIMESTAMP)";
    await conn.query(query, [organizationId, orderId]);

    // StringBuffer itemQuries = StringBuffer();

    for (OrderItem oi in items) {
      int productId = oi.productId;
      int quantity = oi.itemQuantity;
      // itemQuries.write("CALL create_order_item('$orderId', $productId, $quantity); ");
      await conn.query("CALL create_order_item(?, ?, ?)", [orderId, productId, quantity]);
    }

    // var exitcode = await connector.execute_through_ssh(query, (_ , v) {});

    // Finally, close the connection
    await conn.close();
  }

  Future<void> update_order_status(String orderId) async {
    var query = "UPDATE Preisschild.tbl_order as ord " +
        " SET ord.order_status = 'RECEIVE', " +
        " ord.modified_date = CURRENT_TIMESTAMP " +
        " WHERE ord.order_id = '$orderId'";
    var exitcode = await connector.execute_through_ssh(query, (_ , v) {});
  }

}
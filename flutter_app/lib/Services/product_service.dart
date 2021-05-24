import 'dart:async';

import 'package:flutter_app/data_access/db_connector.dart';
import 'package:flutter_app/data_access/product_dao.dart';
import 'package:mysql1/mysql1.dart';

class ProductService {

  final DBConnector connector = DBConnector();
  StreamController<ProductDao> productStream = StreamController();
  StreamController<String> categoryStream = StreamController();

  // TODO try to make generic service function
  // TODO make generic function in connector class
  Future<List<ProductDao>> get_all_products() async {

    var query = "SELECT * FROM Preisschild.tbl_product as prd";

    // var exitcode = await connector.execute_through_ssh(query, (_ , v) {
    //   if (v.trim() == "logout") {
    //     productStream.close();
    //   }
    //
    //   List<ProductDao> details = ProductDao.convert(v);
    //
    //   if (details.length > 0) {
    //     for (ProductDao od in details) {
    //       productStream.add(od);
    //     }
    //   }
    // });
    //
    // List<ProductDao> details = [];
    // await for (ProductDao o in productStream.stream) {
    //   details.add(o);
    // }
    //
    // return Future.value(details);

    // Open a connection
    final conn = await MySqlConnection.connect(ConnectionSettings(host: 'db-preisschild.cygfsaorvowd.eu-central-1.rds.amazonaws.com',
        port: 3306,
        user: 'admin_mahbubur',
        password: 'Dark_Fantasy_2021',
        db: 'Preisschild'));

    var result = await conn.query(query);

    List<ProductDao> details = [];

    if (result.isNotEmpty) {
      for (ResultRow r in result) {
        details.add(ProductDao(r.fields["id"], r.fields["title"],
                              r.fields["brand"], r.fields["weight"],
                              r.fields["unit_price"], r.fields["quantity"],
                              r.fields["category"], r.fields["description"],
                              r.fields["short_description"], r.fields["image_url"]));
      }
    }

    // Finally, close the connection
    await conn.close();

    return Future.value(details);
  }

  // ToDo Switch to AWS RDS
  Future<List<String>> get_product_categories(int organizationId) async {
    var query = "SELECT prd.category FROM Preisschild.tbl_product as prd WHERE prd.organization_id = $organizationId GROUP BY prd.category";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        categoryStream.close();
      }

      List<String> details = ProductDao.convertCategory(v);

      if (details.length > 0) {
        for (String c in details) {
          categoryStream.add(c);
        }
      }
    });

    List<String> details = [];
    await for (String c in categoryStream.stream) {
      details.add(c);
    }

    return Future.value(details);
  }

  // ToDo Switch to AWS RDS
  Future<List<ProductDao>> get_products_by_category(int organizationId, String category) async {
    var query = "SELECT * FROM Preisschild.tbl_product as prd WHERE prd.organization_id = $organizationId AND prd.category = '$category'";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        productStream.close();
      }

      List<ProductDao> details = ProductDao.convert(v);

      if (details.length > 0) {
        for (ProductDao od in details) {
          productStream.add(od);
        }
      }
    });

    List<ProductDao> details = [];
    await for (ProductDao o in productStream.stream) {
      details.add(o);
    }

    return Future.value(details);
  }

  // ToDo Switch to AWS RDS
  Future<ProductDao> get_product_by_id(int productId) async {
    var query = "SELECT * FROM Preisschild.tbl_product as prd WHERE prd.id = $productId";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        productStream.close();
      }

      List<ProductDao> details = ProductDao.convert(v);

      if (details.length > 0) {
        for (ProductDao od in details) {
          productStream.add(od);
        }
      }
    });

    List<ProductDao> details = [];
    await for (ProductDao o in productStream.stream) {
      details.add(o);
    }

    return Future.value(details.first);
  }

  Future<List<ProductDao>> get_products_by_title(int organizationId, String title) async {
    // Open a connection
    final conn = await MySqlConnection.connect(ConnectionSettings(host: 'db-preisschild.cygfsaorvowd.eu-central-1.rds.amazonaws.com',
        port: 3306,
        user: 'admin_mahbubur',
        password: 'Dark_Fantasy_2021',
        db: 'Preisschild'));
    print("get_products_by_title ($title) => ");
    String query = "SELECT	prd.id, " +
                    "       prd.title, " +
                    "       REGEXP_REPLACE(LOWER(prd.title), '[[:punct:][:space:]]*', '') as edited_title, " +
                    "       prd.unit_price, " +
                    "       prd.quantity " +
                    " FROM 	Preisschild.tbl_product as prd " +
                    " WHERE 	prd.organization_id = ? " +
                    " AND 	prd.quantity > 2 " +
                    " AND 	REGEXP_REPLACE(LOWER(prd.title), '[[:punct:][:space:]]*', '') LIKE ? " +
                    " LIMIT	2";
    var result = await conn.query(query, [organizationId, "%$title%"]);

    List<ProductDao> details = [];

    print("get_products_by_title ($title) => " + result.length.toString());

    if (result.isNotEmpty) {
      for (ResultRow r in result) {
        ProductDao prd = ProductDao(r.fields["id"], r.fields["title"],
                                    null, 0.00,
                                    r.fields["unit_price"], r.fields["quantity"],
                                    null, null,
                                    null, null);
        prd.productEditedTitle = r.fields["edited_title"];
        details.add(prd);
      }
    }

    // Finally, close the connection
    await conn.close();

    return Future.value(details);
  }
}
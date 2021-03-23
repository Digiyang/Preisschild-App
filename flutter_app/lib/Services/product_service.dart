import 'dart:async';

import 'package:flutter_app/data_access/db_connector.dart';
import 'package:flutter_app/data_access/product_dao.dart';

class ProductService {

  final DBConnector connector = DBConnector();
  StreamController<ProductDao> productStream = StreamController();
  StreamController<String> categoryStream = StreamController();

  // TODO try to make generic service function
  // TODO make generic function in connector class
  Future<List<ProductDao>> get_all_products() async {

    var query = "SELECT * FROM Preisschild.tbl_product as prd";

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

}
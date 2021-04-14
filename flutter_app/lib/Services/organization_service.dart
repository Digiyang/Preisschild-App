import 'dart:async';

import 'package:flutter_app/data_access/db_connector.dart';
import 'package:flutter_app/data_access/location_dao.dart';
import 'package:flutter_app/data_access/order_dao2.dart';
import 'package:flutter_app/data_access/organization_dao.dart';
import 'package:flutter_app/data_access/product_dao.dart';

class OrganizationService {
  final DBConnector connector = DBConnector();
  StreamController<OrganizationDao> organizationStream = StreamController();
  StreamController<LocationDao> locationStream = StreamController();
  StreamController<OrderDao> orderStream = StreamController();
  StreamController<ProductDao> productStream = StreamController();

  Future<OrganizationDao> get_organization(String name) async {
    var query = "SELECT org.*, org_settings.locale, org_settings.welcome_text FROM Preisschild.tbl_organization org, Preisschild.tbl_settings org_settings WHERE org.settings_id = org_settings.id AND org.name = '$name'";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        organizationStream.close();
      }

      List<OrganizationDao> details = OrganizationDao.convert(v);

      if (details.length > 0) {
        for (OrganizationDao od in details) {
          organizationStream.add(od);
        }
      }
    });

    List<OrganizationDao> details = [];
    await for (OrganizationDao od in organizationStream.stream) {
      details.add(od);
    }

    return Future.value(details.first);
  }

  Future<List<LocationDao>> get_organization_locations(int organizationId) async {
    var query = "SELECT loc.* FROM Preisschild.tbl_location loc WHERE loc.organization_id = $organizationId";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        locationStream.close();
      }

      List<LocationDao> details = LocationDao.convert(v);

      if (details.length > 0) {
        for (LocationDao ld in details) {
          locationStream.add(ld);
        }
      }
    });

    List<LocationDao> details = [];
    await for (LocationDao ld in locationStream.stream) {
      details.add(ld);
    }

    return Future.value(details);
  }

  Future<List<OrderDao>> get_organization_orders(int organizationId) async {
    var query = "SELECT ord.* FROM Preisschild.tbl_order ord WHERE ord.organization_id = $organizationId";

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
    await for (OrderDao od in orderStream.stream) {
      details.add(od);
    }

    return Future.value(details);
  }

  Future<List<ProductDao>> get_organization_products(int organizationId) async {
    var query = "SELECT prd.* FROM Preisschild.tbl_product prd WHERE prd.organization_id = $organizationId";

    var exitcode = await connector.execute_through_ssh(query, (_ , v) {
      if (v.trim() == "logout") {
        productStream.close();
      }

      List<ProductDao> details = ProductDao.convert(v);

      if (details.length > 0) {
        for (ProductDao pd in details) {
          productStream.add(pd);
        }
      }
    });

    List<ProductDao> details = [];
    await for (ProductDao pd in productStream.stream) {
      details.add(pd);
    }

    return Future.value(details);
  }
}
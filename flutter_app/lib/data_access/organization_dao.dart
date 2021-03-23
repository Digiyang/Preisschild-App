import 'package:flutter_app/data_access/location_dao.dart';
import 'package:flutter_app/data_access/order_dao2.dart';
import 'package:flutter_app/data_access/product_dao.dart';

class OrganizationDao {
  int id;
  String name;
  String category;
  String logoUrl;
  String imageUrl;
  String description;
  String shortDescription;
  List<LocationDao> locations;
  List<OrderDao> orders;
  List<ProductDao> products;

  OrganizationDao (int id,
                    String name, String category,
                    String logoUrl, String imageUrl,
                    String description, String shortDescription) {

    this.id = id;
    this.name = name;
    this.category = category;
    this.logoUrl = logoUrl;
    this.imageUrl = imageUrl;
    this.description = description;
    this.shortDescription = shortDescription;
    this.locations = [];
    this.orders = [];
    this.products = [];
  }

  int get organizationId {
    return id;
  }

  String get organizationName {
    return name;
  }

  String get organizationCategory {
    return category;
  }

  String get logo {
    return logoUrl;
  }

  String get image {
    return imageUrl;
  }

  String get orgDescription {
    return description;
  }

  String get orgShortDescription {
    return shortDescription;
  }

  List<LocationDao> get orgLocations {
    return locations;
  }

  List<OrderDao> get orgOrders {
    return orders;
  }

  List<ProductDao> get orgProducts {
    return products;
  }

  void set orgLocations(List<LocationDao> locs) {
    this.locations.addAll(locs);
  }

  void set orgOrders(List<OrderDao> ords) {
    this.orders.addAll(ords);
  }

  void set orgProducts(List<ProductDao> prds) {
    this.products.addAll(prds);
  }

  static List<OrganizationDao> convert(String v) {
    List<String> lines = v.split("\n");
    List<OrganizationDao> org_details = [];

    for (String l in lines) {
      if (l.contains("|")) {

        if (l.contains("id")) {
          continue;
        }

        List<String> values = l.split("|");
        org_details.add(OrganizationDao(int.parse(values[1].trim()),
                                        values[2].trim(), values[3].trim(),
                                        values[4].trim(), values[5].trim(),
                                        values[6].trim(), values[7].trim()));
        }
    }

    return org_details;
  }
}
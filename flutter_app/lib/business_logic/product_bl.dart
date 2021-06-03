import 'dart:io';

import 'package:flutter_app/data_access/product_dao.dart';
import 'package:flutter_app/Services/product_service.dart';

class ProductBL {

  final ProductService service = ProductService();

  //TODO try to make generic bl functions
  Future<List<ProductDao>> get_all_products() async {
    List<ProductDao> details = await service.get_all_products();
    return Future.value(details);
  }

  Future<List<String>> get_product_categories(int organizationId) async {
    List<String> details = await service.get_product_categories(organizationId);
    return Future.value(details);
  }

  Future<List<ProductDao>> get_products_by_category(int organizationId, String category) async {
    List<ProductDao> details = await service.get_products_by_category(organizationId, category);
    return Future.value(details);
  }

  Future<ProductDao> get_product_by_id(int productId) async {
    ProductDao detail = await service.get_product_by_id(productId);
    return Future.value(detail);
  }

  Future<List<ProductDao>> get_products_by_title(int organizationId, String title, double weight, int limit) async {
    List<ProductDao> details = await service.get_products_by_title(organizationId, title, weight, limit);
    return Future.value(details);
  }
}

void main() {
  String quantity = stdin.readLineSync();
  if (quantity.contains("number to")) {
    quantity = quantity.replaceAll("number to", "number two");
  }

  if (quantity.contains("to")) {
    quantity = quantity.replaceAll("to", "two");
  }

  quantity = quantity.replaceAll(RegExp(r"number|hundred|thousand|\s+"), "")
                      .splitMapJoin(RegExp(r"ty"), onMatch: (m) => "", onNonMatch: (n) => n)
                      .splitMapJoin((RegExp(r'[a-z]{4}teen')),
                                      onMatch:    (m) => "1" + m[0].splitMapJoin(RegExp(r"teen"),
                                                                                onMatch: (m) => "",
                                                                                onNonMatch: (n) => n),
                                      onNonMatch: (n) => n)
                      .replaceAll("one", "1").replaceAll(RegExp(r"two|twen"), "2")
                      .replaceAll(RegExp(r"three|thir"), "3").replaceAll(RegExp(r"four|for"), "4")
                      .replaceAll(RegExp(r"five|fif"), "5").replaceAll("six", "6")
                      .replaceAll("seven", "7").replaceAll(RegExp(r"eight|eigh"), "8")
                      .replaceAll("nine", "9").replaceAll("ten", "10")
                      .replaceAll("eleven", "11").replaceAll("twelve", "12");

  print("#blackdiamond => " + quantity);
}

// void main() async {
//   // List<ProductDao> details = await ProductBL().get_all_products();
//   List<ProductDao> details = await ProductBL().get_products_by_title(1, "dinkel", 0.00, 2);
//   // List<ProductDao> details = await ProductBL().get_products_by_category(1, "Category 2");
//   // List<ProductDao> details = [await ProductBL().get_product_by_id(2)];
//   print("Resultset length: " + details.length.toString());
//   print("------------------------------------------");
//   for (ProductDao p in details) {
//     print(p.productId);
//     print(p.productTitle);
//     print(p.productBrand);
//     print(p.productCategory);
//     print(p.productWeight.toString() + " gm");
//     print(p.productQuantity);
//     print(p.unitPrice);
//     print(p.productShortDescription);
//     print(p.productDescription);
//     print(p.productImageUrl);
//     print("------------------------------------------");
//   }
//
//   // List<String> categories = await ProductBL().get_product_categories(1);
//   // print("Resultset length: " + categories.length.toString());
//   // print("------------------------------------------");
//   // for (String c in categories) {
//   //   print(c);
//   //   print("------------------------------------------");
//   // }
// }
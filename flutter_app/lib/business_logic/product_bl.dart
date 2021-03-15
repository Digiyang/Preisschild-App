import 'package:flutter_app/data_access/product_dao.dart';
import 'package:flutter_app/Services/product_service.dart';

class ProductBL {

  final ProductService service = ProductService();

  //TODO try to make generic bl functions
  Future<List<ProductDao>> get_all_products() async {
    List<ProductDao> details = await service.get_all_products();
    return Future.value(details);
  }

  Future<List<ProductDao>> get_products_by_category(String category) async {
    List<ProductDao> details = await service.get_products_by_category(category);
    return Future.value(details);
  }

  Future<ProductDao> get_product_by_id(int productId) async {
    ProductDao detail = await service.get_product_by_id(productId);
    return Future.value(detail);
  }
}

void main() async {
  List<ProductDao> details = await ProductBL().get_all_products();
  // List<ProductDao> details = await ProductBL().get_products_by_category("Category 2");
  // List<ProductDao> details = [await ProductBL().get_product_by_id(2)];
  print("Resultset length: " + details.length.toString());
  print("------------------------------------------");
  for (ProductDao p in details) {
    print(p.productId);
    print(p.productTitle);
    print(p.productCategory);
    print(p.productWeight.toString() + " gm");
    print(p.productQuantity);
    print(p.unitPrice);
    print(p.productShortDescription);
    print(p.productDescription);
    print(p.productImageUrl);
    print("------------------------------------------");
  }
}
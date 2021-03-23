import 'package:flutter_app/Services/organization_service.dart';
import 'package:flutter_app/data_access/location_dao.dart';
import 'package:flutter_app/data_access/order_dao2.dart';
import 'package:flutter_app/data_access/organization_dao.dart';
import 'package:flutter_app/data_access/product_dao.dart';

class OrganizationBL {

  final OrganizationService service = OrganizationService();

  //TODO try to make generic bl functions
  Future<OrganizationDao> get_organization(String name) async {
    OrganizationDao detail = await service.get_organization(name);
    return Future.value(detail);
  }

  Future<List<LocationDao>> get_organization_locations(int organizationId) async {
    List<LocationDao> details = await service.get_organization_locations(organizationId);
    return Future.value(details);
  }

  Future<List<OrderDao>> get_organization_orders(int organizationId) async {
    List<OrderDao> details = await service.get_organization_orders(organizationId);
    return Future.value(details);
  }

  Future<List<ProductDao>> get_organization_products(int organizationId) async {
    List<ProductDao> details = await service.get_organization_products(organizationId);
    return Future.value(details);
  }
}

void main() async {

  fetchOrganization();
  // fetchOrganizationLocations();
  // fetchOrganizationProducts();
  // fetchOrganizationOrders();
}

void fetchOrganization() async {
  OrganizationDao organization = await OrganizationBL().get_organization("Bakery B");
  print("Resultset length: " + (organization == null ? "0" : "1"));
  print("------------------------------------------");
  print(organization.organizationId);
  print(organization.organizationName);
  print(organization.organizationCategory);
  print(organization.orgShortDescription);
  print(organization.orgDescription);
  print(organization.logo);
  print(organization.image);
  print("------------------------------------------");
}

void fetchOrganizationLocations() async {
  List<LocationDao> details = await OrganizationBL().get_organization_locations(1);
  print("Resultset length: " + details.length.toString());
  print("------------------------------------------");
  for (LocationDao l in details) {
    print(l.locationId);
    print(l.streetName);
    print(l.houseNo);
    print(l.postCode.toString());
    print(l.cityName);
    print(l.countryName);
    print(l.phoneNumber);
    print(l.websiteUrl);
    print(l.mapCoordinateValues);
    print("------------------------------------------");
  }
}

void fetchOrganizationProducts() async {
  List<ProductDao> details = await OrganizationBL().get_organization_products(1);
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

void fetchOrganizationOrders() async {
  List<OrderDao> details = await OrganizationBL().get_organization_orders(1);
  print("Resultset length: " + details.length.toString());
  print("------------------------------------------");
  for (OrderDao o in details) {
    print(o.orderID);
    print(o.orderDate.toString());
    print(o.orderPrice.toString());
    print(o.status);
    print(o.creationDate.toString());
    print(o.modifyDate.toString());
    print("------------------------------------------");
  }
}


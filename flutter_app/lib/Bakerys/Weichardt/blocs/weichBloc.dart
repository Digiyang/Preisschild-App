import 'package:flutter/material.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/productList.dart';

enum ShopState {
  normal,
  details,
  cart,
}

class WeichBloc with ChangeNotifier {
  ShopState state = ShopState.normal;

  List<WeichProduct> inventory = List.of(weichProducts);
  List<AddItem> cart = [];

  void toNormal() {
    state = ShopState.normal;
    super.notifyListeners();
  }

  void toCart() {
    state = ShopState.cart;
    super.notifyListeners();
  }

  void addProduct(WeichProduct product) {
    for (AddItem item in cart) {
      if (item.product.name == product.name) {
        item.add();
        notifyListeners();
        return;
      }
    }
    cart.add(AddItem(product: product));
    notifyListeners();
  }

  void throwProduct(AddItem product) {
    cart.remove(product);
    notifyListeners();
  }

  int sumItems() => cart.fold<int>(
      0, (previousValue, element) => previousValue + element.number);

  double sumPrice() => cart.fold<double>(
      0,
      (previousValue, element) =>
          previousValue + (element.number * element.product.price));
}

class AddItem {
  AddItem({this.number = 1, @required this.product});

  int number;
  final WeichProduct product;

  void add() {
    number++;
  }

  void delete() {
    number--;
  }
}

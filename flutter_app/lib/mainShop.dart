import 'package:flutter/material.dart';
import 'package:flutter_app/Bakerys/Weichardt/screens/shopInventoryScrenn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(scaffoldBackgroundColor: Colors.blueGrey),
        home: ShopInventoryHome());
  }
}

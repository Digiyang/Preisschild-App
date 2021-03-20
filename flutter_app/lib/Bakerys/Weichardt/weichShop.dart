import 'package:bakery/Bakerys/Weichardt/screens/shopScreen.dart';
import 'package:bakery/screens/bar.dart';
import 'package:bakery/widgets/navigator.dart';
import 'package:flutter/material.dart';

class WeichShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: appBar(context),
      body: ShopScreen(),
    );
  }
}


import 'package:flutter_app/Bakerys/Weichardt/screens/shopScreen.dart';
import 'package:flutter_app/screens/bar.dart';
import 'package:flutter_app/widgets/navigator.dart';
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


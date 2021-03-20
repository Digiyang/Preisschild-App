import 'package:bakery/screens/bar.dart';
import 'package:bakery/screens/body.dart';
import 'package:bakery/widgets/navigator.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: appBar(context),
      body: Body(),
    );
  }
}


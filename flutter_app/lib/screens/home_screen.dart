import 'package:flutter_app/screens/bar.dart';
import 'package:flutter_app/screens/body.dart';
import 'package:flutter_app/widgets/navigator.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: PreisschildBar().appBar(context),
      body: Body(),
    );
  }
}

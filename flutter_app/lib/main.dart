import 'package:flutter/material.dart';
import 'package:flutter_app/business_logic/order_bl.dart';
import 'package:flutter_app/data_access/order_dao.dart';
import 'package:flutter_app/widgets/navigator.dart';
import 'package:flutter_app/blocs/appBlocs.dart';
import 'package:flutter_app/widgets/HomeScreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppBlocs(),
      child: MaterialApp(
        title: 'Preisschild',
        home: HomeScreen(),
      ),
    );
  }
}
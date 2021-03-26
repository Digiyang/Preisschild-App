import 'package:flutter_app/blocs/appBlocs.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppBlocs(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: new ThemeData(scaffoldBackgroundColor: Colors.blueGrey),
        home: HomeScreen(),
      ),
    );
  }
}

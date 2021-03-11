import 'package:flutter/material.dart';
import 'package:flutter_app/order_bl.dart';
import 'package:flutter_app/order_dao.dart';
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Preisschild'),
      ),
      body: Center(
        // child: Text('Test'),
        child: _buildSuggestions(),
      ),
    );
  }

  final _suggestions = <OrderDao>[];
  final _biggerFont = TextStyle(fontSize: 18.0);
  final order_bl = OrderBL();

  Widget _buildSuggestions() {
    return ListView.builder(itemBuilder: (context, i) {
      if (i.isOdd) {
        return Divider();
      }
      final index = i ~/ 2;
      if (index >= _suggestions.length) {
        _suggestions.addAll(order_bl.get_order_details());
      }
      return _buildRow(_suggestions.isEmpty? null : _suggestions[index]);
    });
  }

  Widget _buildRow(OrderDao details) {
      String text = "";
      if (details != null) {
        text = details.orderId + ", " +
                details.orderDate.toString() + ", " +
                details.orderStatus + ", " +
                details.totalPrice.toString() + ", " +
                details.itemName + ", " +
                details.itemQuantity.toString() + ", " +
                details.formattedItemPrice;
      }
      return ListTile(
          title: Text(text, style: _biggerFont),
          trailing: Icon(Icons.favorite_border, color: Colors.red)
      );
  }
}
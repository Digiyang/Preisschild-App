import 'package:flutter/material.dart';

class ShopInventoryHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              children: [
                BackButton(
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Bread', style: TextStyle(color: Colors.black)),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
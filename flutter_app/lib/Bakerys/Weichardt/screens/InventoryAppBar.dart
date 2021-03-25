import 'package:flutter/material.dart';

class InventoryAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      color: Colors.blueGrey,
      child: Row(
        children: [
          BackButton(
            color: Colors.white,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text('Bread', style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () => null,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

AppBar appBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.blueGrey,
    elevation: 0,
    title: RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: "Preis", style: TextStyle(color: Colors.white70)
          ),
          TextSpan(text: "Schild", style: TextStyle(color: Colors.white))
        ]
      ),
    ),
    actions: <Widget>[
      Icon(Icons.notifications_none, size: 30.0),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        )
      ],
  );
}
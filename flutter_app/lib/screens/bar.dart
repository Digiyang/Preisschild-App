import 'package:flutter/material.dart';

import '../vocal_assistant.dart';

AppBar appBar(BuildContext context) {

  VocalAssistant vocalAssistant = VocalAssistant();

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
      GestureDetector(
          child: Icon(Icons.mic_none_rounded, size: 30.0),
          onTap: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) { return vocalAssistant; }))},
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        )
      ],
  );
}
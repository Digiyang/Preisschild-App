import 'package:flutter/material.dart';
import 'package:flutter_app/screens/settings.dart';

import 'package:flutter_app/screens/vocal_assistant.dart';

AppBar appBar(BuildContext context) {

  VocalAssistant vocalAssistant = VocalAssistant();
  Settings settings = Settings();

  return AppBar(
    backgroundColor: Colors.blueGrey,
    elevation: 0,
    title:  Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_rounded, size: 30.0),
            onPressed: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) { return settings; }))},
          ),
          SizedBox(width: 60,),
          RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: "Preis", style: TextStyle(color: Colors.white70)
                  ),
                  TextSpan(text: "Schild", style: TextStyle(color: Colors.white))
                ]
              ),
          ),
        ],
      ),
    actions: <Widget>[
      Icon(Icons.notifications_none, size: 30.0),
      IconButton(
          icon: Icon(Icons.mic_none_rounded, size: 30.0),
          onPressed: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) { return vocalAssistant; }))},
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        )
      ],
  );
}
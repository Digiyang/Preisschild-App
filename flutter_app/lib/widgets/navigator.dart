import 'package:flutter/material.dart';
import 'package:flutter_app/screens/vocal_assistant.dart';

class NavDrawer extends StatelessWidget {

  VocalAssistant vocalAssistant = VocalAssistant();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                ),
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.record_voice_over),
            title: Text('Vocal Assistant'),
            onTap: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) { return vocalAssistant; }))},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
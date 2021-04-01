import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart';

class Settings extends StatefulWidget {
  @override
  SettingsFormState createState() {
    return SettingsFormState();
  }
}

class SettingsFormState extends State<Settings> {
  String _currentLocaleId = 'de_DE';
  List<LocaleName> _localeNames = [LocaleName('en_US', 'English'), LocaleName('de_DE', 'Deutsch')];

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final welcomeTextController = TextEditingController();

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    welcomeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Settings';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Row(
                    children: <Widget>[
                      Text('Locale'),
                      SizedBox(width: 18,),
                      DropdownButton(
                        onChanged: (selectedVal) => _switchLang(selectedVal),
                        value: _currentLocaleId,
                        items: _localeNames
                            .map(
                              (localeName) => DropdownMenuItem(
                            value: localeName.localeId,
                            child: Text(localeName.name),
                          ),
                        )
                            .toList(),
                      )
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: welcomeTextController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Welcome Text',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Welcome Text';
                    }
                    return null;
                  },
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
                    ),
                    SizedBox(width: 18,),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          print(welcomeTextController.text + " " + _currentLocaleId);
                        }
                      },
                      child: Text('Save'),
                    )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
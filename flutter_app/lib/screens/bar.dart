import 'package:flutter/material.dart';
import 'package:flutter_app/business_logic/settings_bl.dart';
import 'package:flutter_app/data_access/settings_dao.dart';
import 'package:flutter_app/screens/settings.dart';

// import 'package:flutter_app/screens/vocal_assistant.dart';
import 'package:flutter_app/screens/vocal_assistant_v1.2.dart';

class PreisschildBar {

  bool is_VA_Initialized = false;
  bool is_VA_Running = false;

  VocalAssistant va = VocalAssistant();
  Settings settings = Settings();

  AppBar appBar(BuildContext context) {
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
          // onPressed: () => {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) { return vocalAssistant; }))},
          onPressed: () {
              print("start Preisschild VA");
              start_vocal_assistant();
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
        )
      ],
    );
  }

  Future<void> start_vocal_assistant() async {

    // TODO fetch organization id and organization basic object from database
    // ToDo update organization object with settings
    SettingsDao settings = await SettingsBL().get_settings_by_org_id(1);
    print(settings.welcomeSpeech);

    if (!this.is_VA_Initialized) {
      print("start VA initialization.");
      await this.va.requestForPermissions();
      this.va.initTts();
      await this.va.initSpeechState(settings);
      this.is_VA_Initialized = true;
      print("end VA initialization.");
    }

    if (va.hasSpeech) {
      va.isNeedToRequestAgain = true;
      print("#hello va 1.2");
      while(va.isNeedToRequestAgain) {
        await va.requestForProductTitle();
        print("#hello va 1.2.1 => " + (va.isListening ? "listening" : "not listening"));
        if (!va.isListening) {
          print("#hello va 1.2.2");
          await va.listenForProductTitle();
          print("#hello va 1.2.3");
        }
        // ToDo adjust delay duration with listenFor and pauseFor in speech.listen method
        await Future.delayed(Duration(seconds: 24));
      }
      await va.requestForConfirmation();
      print("#hello va 1.2.4 => " + (va.isListening ? "listening" : "not listening"));
      if (!va.isListening) {
        print("#hello va 1.2.5");
        await va.listenForConfirmation();
        print("#hello va 1.2.6");
      }
      // ToDo adjust delay duration with listenFor and pauseFor in speech.listen method
      await Future.delayed(Duration(seconds: 24));
    }
  }
}

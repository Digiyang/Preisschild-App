import 'package:flutter/material.dart';
import 'package:flutter_app/business_logic/settings_bl.dart';
import 'package:flutter_app/data_access/product_dao.dart';
import 'package:flutter_app/data_access/settings_dao.dart';
import 'package:flutter_app/screens/settings.dart';

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
              print("#blackdiamond start preisschild vocal assistant");
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
    print("#blackdiamond settings language => " + settings.language);
    print("#blackdiamond settings welcome text => " + settings.welcomeSpeech);

    if (!this.is_VA_Initialized) {
      print("#blackdiamond start vocal assistant initialization.");
      await this.va.requestForPermissions();
      this.va.initTts();
      await this.va.initSpeechState(settings);
      this.is_VA_Initialized = true;
      print("#blackdiamond end vocal assistant initialization.");
    }

    if (va.hasSpeech) {
      await va.sayWelcomeText(settings);
      va.initProductLookup();
      while(va.isNeedToRequestAgain) {
        await va.requestForProductTitle();
        if (!va.isListening) {
          await va.listenForProductTitle();
        }
        // ToDo adjust delay duration with listenFor and pauseFor in speech.listen method
        await Future.delayed(Duration(seconds: 16)); // 24, 20
      }
      if (va.selectedItems.isNotEmpty) {
        for (ProductDao prd in va.selectedItems) {
          va.selectedProductId = prd.productId;
          va.selectedProductUnitPrice = prd.unitPrice;
          await va.requestForItemQuantityConfirmation(prd.productTitle);
          if (!va.isListening) {
            await va.listenForItemQuantityConfirmation();
          }
          // ToDo adjust delay duration with listenFor and pauseFor in speech.listen method
          await Future.delayed(Duration(seconds: 16)); // 24, 20
        }
        await va.placeOrder();
      }
    }
  }
}

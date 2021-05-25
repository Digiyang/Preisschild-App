import 'dart:async';
import 'dart:math';

import 'package:flutter_app/business_logic/order_bl.dart';
import 'package:flutter_app/data_access/order_item.dart';
import 'package:flutter_app/data_access/product_dao.dart';
import 'package:flutter_app/data_access/settings_dao.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

import '../business_logic/product_bl.dart';

enum TtsState { playing, stopped, paused, continued }

class VocalAssistant {
  final translator = GoogleTranslator();

  bool _hasSpeech = false;
  // sounds in DB. need to check from low frequency to high frequency
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  ///////////////////////////////////////////////////////
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  final SpeechToText speech = SpeechToText();

  /////////////////==:TTS:==//////////////////////////////////////
  FlutterTts flutterTts;
  String language;
  double volume = 0.64;
  double pitch = 1.2;
  double rate = 0.76;
  bool isCurrentLanguageInstalled = false;

  String _newVoiceText;
  String staticResponse = '';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;
  ////////////////////////////////////////////////////////////////
  final ProductBL productBL = ProductBL();
  final OrderBL orderBL = OrderBL();
  List<ProductDao> products = [];
  List<ProductDao> selectedProducts = [];
  List<OrderItem> orderItems = [];
  int selectedProductId = 0;
  double selectedProductUnitPrice = 0.0;
  bool isNeedToRequestAgain = true;
  /////////////////////////////////////////////////////////////////

  bool get hasSpeech {
    return _hasSpeech;
  }

  bool get isListening {
    return speech.isListening;
  }

  List<ProductDao> get selectedItems {
    return selectedProducts;
  }

  set selectedItemId(int id) {
    this.selectedProductId = id;
  }

  set selectedItemUnitPrice(double unitPrice) {
    this.selectedProductUnitPrice = unitPrice;
  }

  Future<void> requestForPermissions() async {
    print("#blackdiamond request for permission");

    if (await Permission.speech.request().isGranted) {
      print("Speech permission is granted.");
    }
    if (await Permission.microphone.request().isGranted) {
      print("Microphone permission is granted.");
    }
  }

  initTts() {
    print("#blackdiamond initialize text to speech");

    flutterTts = FlutterTts();

    if (isAndroid) {
      _getEngines();
    }

    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
      ttsState = TtsState.stopped;
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        print("Paused");
        ttsState = TtsState.paused;
      });

      flutterTts.setContinueHandler(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    }

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      ttsState = TtsState.stopped;
    });
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(_newVoiceText);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }

  Future<void> stopSpeaking() async {
    var result = await flutterTts.stop();
    if (result == 1) ttsState = TtsState.stopped;
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) ttsState = TtsState.paused;
  }

  Future<void> initSpeechState(SettingsDao settings) async {
    print("#blackdiamond initialize speech state");

    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);

    if (hasSpeech) {
      _currentLocaleId = settings.language;
      language = _currentLocaleId;
      flutterTts.setLanguage(language);
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    }

    _hasSpeech = hasSpeech;
  }

  Future<void> sayWelcomeText(SettingsDao settings) async {
    print("#blackdiamond say welcome text");

    _currentLocaleId = settings.language;

    // Welcome Text
    _newVoiceText = settings.welcomeSpeech;
    print("#blackdiamond welcome text => $_newVoiceText");

    if (_currentLocaleId != 'en_US') {
      Translation translation = await translator.translate(_newVoiceText, from: 'en', to: _currentLocaleId.substring(0, 2));
      _newVoiceText = translation.toString().trim();
      print("#blackdiamond welcome text (after translation) => $_newVoiceText");
    }

    await _speak();
  }

  void initProductLookup() {
    print("#blackdiamond initialize product lookup");
    isNeedToRequestAgain = true;
    products.clear();
    selectedProducts.clear();
  }

  Future<void> requestForProductTitle() async {
    print("#blackdiamond request for product title");

    _newVoiceText = "Please tell me which item do you want to buy?";
    print("#blackdiamond product title => $_newVoiceText");

    if (language != 'en_US') {
      Translation translation = await translator.translate(_newVoiceText, from: 'en', to: _currentLocaleId.substring(0, 2));
      _newVoiceText = translation.toString().trim();
      print("#blackdiamond product title (after translation) => $_newVoiceText");
    }

    await _speak();
  }

  Future<void> listenForProductTitle() async {
    print("#blackdiamond listen for product title");

    lastWords = '';
    lastError = '';

    await speech.listen(
        onResult: productTitleListener,
        listenFor: Duration(seconds: 12),
        pauseFor: Duration(seconds: 6),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  ProductDao get_product_from_cache(String title) {
    ProductDao product;

    if (products.isEmpty) {
      print("$title: Cache Lookup => Now products in cache => 0");
    }

    if (products.isNotEmpty) {
      print("$title: Cache Lookup => Now products in cache => " + products.length.toString());
      for (ProductDao prd in products) {
        // ToDo enable when regex is prefectly worked
        // if (prd.productEditedTitle.contains(title)) {
        if (prd.productTitle.contains(title)) {
          product = prd;
          print("$title: Cache Lookup => Product Found");
          break;
        }
      }
    }

    return product;
  }

  Future<void> productTitleListener(SpeechRecognitionResult result) async {
    ++resultListened;
    print('#blackdiamond product title listener $resultListened');

    isNeedToRequestAgain = true;

    String title = result.recognizedWords.toLowerCase();
    lastWords = '${result.recognizedWords} - ${result.finalResult}';

    String regconizedWords = title;
    regconizedWords = regconizedWords.replaceAll("ss", "ß").trim();
    print("#blackdiamond recognized words => $regconizedWords");

    Translation translation;
    if (_currentLocaleId != 'en_US') {
      translation = await translator.translate(regconizedWords, from: _currentLocaleId.substring(0, 2), to: 'en');
      regconizedWords = translation.toString().trim().toLowerCase();
      print("#blackdiamond recognized words (after translation) => $regconizedWords");
    }

    // ToDo regex
    // regconizedWords = regconizedWords.replaceAll(RegExp(r"[\p{Punct}\s]*"), "");
    print("#blackdiamond recognized words => $regconizedWords");
    
    if (regconizedWords.contains("stop") || regconizedWords.contains("no") ||
        regconizedWords.contains("finished") || regconizedWords.contains("enough")) {
      isNeedToRequestAgain = false;
      return;
    }

    // ToDo regex
    title = title.replaceAll("ss", "ß").trim();
                  // .replaceAll(RegExp(r"[\p{Punct}\s]*"), "");
                  // .replaceAll(RegExp(r"[\s]*"), "");
    print("#blackdiamond product title => $title");

    // Product lookup in the cache
    ProductDao product = get_product_from_cache(title);
    if (product != null && product.productId > 0) {
      selectedProducts.add(product);
      _newVoiceText = "Here is your item of choice: each " + product.productTitle +
                      " price is " + product.unitPrice.toStringAsFixed(2) + " euro";
    } else {
      // ToDo fetch organization id from database
      int organizationId = 1;

      // Product lookup in the AWS RDS
      products = await productBL.get_products_by_title(1, title);

      if (products.isNotEmpty) {
        if (products.length == 1) {
          selectedProducts.add(products.first);
          _newVoiceText = "Here is your item of choice: each " + products.first.productTitle +
                          " price is " + products.first.unitPrice.toStringAsFixed(2) + " euro";
        } else {
          _newVoiceText = "I found some similar items that you are looking for. " +
                          "They are " + products.map((e) => e.productTitle).join(" and ") + ". ";
        }
      } else {
        _newVoiceText = "Sorry, I can not find any items of your choice.";
      }
    }

    print("#blackdiamond product lookup result => $_newVoiceText");

    if (_currentLocaleId != 'en_US' && _newVoiceText.isNotEmpty) {
      translation = await translator.translate(_newVoiceText, from: 'en', to: _currentLocaleId.substring(0, 2));
      _newVoiceText = translation.toString().trim();
      print("#blackdiamond product lookup result (after translation) => $_newVoiceText");
    }

    await _speak();
  }

  Future<void> requestForItemQuantityConfirmation(String productTitle) async {
    print("#blackdiamond request for item quantity confirmation");

    _newVoiceText = "Please tell me how many $productTitle, do you want to buy?";
    print("#blackdiamond confirmation => $_newVoiceText");

    if (language != 'en_US') {
      Translation translation = await translator.translate(_newVoiceText, from: 'en', to: _currentLocaleId.substring(0, 2));
      _newVoiceText = translation.toString().trim();
      print("#blackdiamond confirmation (after translation) => $_newVoiceText");
    }

    await _speak();
  }

  Future<void> listenForItemQuantityConfirmation() async {
    print("#blackdiamond listen for item quantity confirmation");

    lastWords = '';
    lastError = '';

    await speech.listen(
        onResult: confirmItemQuantityListener,
        listenFor: Duration(seconds: 12),
        pauseFor: Duration(seconds: 6),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  Future<void> confirmItemQuantityListener(SpeechRecognitionResult result) async {
    ++resultListened;
    print('#blackdiamond confirm item quantity listener $resultListened');

    Translation translation;
    String quantity = result.recognizedWords.trim().toLowerCase();

    lastWords = '${result.recognizedWords} - ${result.finalResult}';
    print("#blackdiamond product quantity => $quantity");

    if (_currentLocaleId != 'en_US') {
      translation = await translator.translate(quantity, from: _currentLocaleId.substring(0, 2), to: 'en');
      quantity = translation.toString().trim().toLowerCase();
      print("#blackdiamond product quantity (after translation) => $quantity");
    }

    if (quantity.contains("number to")) {
      quantity = quantity.replaceAll("number to", "number two");
    }

    if (quantity.contains("to")) {
      quantity = quantity.replaceAll("to", "two");
    }

    quantity = quantity.replaceAll("number ", "").replaceAll("one", "1")
                      .replaceAll("two", "2").replaceAll("three", "3")
                      .replaceAll("four", "4").replaceAll("five", "5")
                      .replaceAll("six", "6").replaceAll("seven", "7")
                      .replaceAll("eight", "8").replaceAll("nine", "9");

    var orderItem = OrderItem(selectedProductId, int.parse(quantity));
    orderItem.unitPrice = selectedProductUnitPrice;

    orderItems.add(orderItem);

    _newVoiceText = "Thank you for your confirmation.";
    print("#blackdiamond confirm item quantity result => $_newVoiceText");

    if (_currentLocaleId != 'en_US' && _newVoiceText.isNotEmpty) {
      translation = await translator.translate(_newVoiceText, from: 'en', to: _currentLocaleId.substring(0, 2));
      _newVoiceText = translation.toString().trim();
      print("#blackdiamond confirm item quantity result (after translation) => $_newVoiceText");
    }

    await _speak();
  }

  Future<void> placeOrder() async {
    print('#blackdiamond place order');
    // ToDo fetch organization id from database
    int organizationId = 1;
    // ToDo generate QR-Code and use it as orderId
    String orderId = "BASH-" + (new Random().nextInt(999999) + 100000).toString();
    // ToDo feature to add more than one items in the order list
    // ToDo (instance variable product list has only one element at the end, will be needed to sperate and use another list for selected products)
    await orderBL.create_order_with_items(organizationId, orderId, orderItems);

    double totalPrice = 0.0;
    for (OrderItem oi in orderItems) {
      totalPrice += (oi.unitPrice * oi.itemQuantity);
    }

    _newVoiceText = "Your order is confirmed and total price is " + totalPrice.toStringAsFixed(2) + " euro";
    print("#blackdiamond place order result => $_newVoiceText");

    if (_currentLocaleId != 'en_US' && _newVoiceText.isNotEmpty) {
      Translation translation = await translator.translate(_newVoiceText, from: 'en', to: _currentLocaleId.substring(0, 2));
      _newVoiceText = translation.toString().trim();
      print("#blackdiamond place order result (after translation) => $_newVoiceText");
    }

    await _speak();
  }

  Future<void> startListening() async {
    lastWords = '';
    lastError = '';

    staticResponse = '';

    await speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 12),
        pauseFor: Duration(seconds: 6),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  void stopListening() {
    speech.stop();
    level = 0.0;
  }

  void cancelListening() {
    speech.cancel();
    level = 0.0;
  }

  Future<void> resultListener(SpeechRecognitionResult result) async {
    ++resultListened;
    print('Result listener $resultListened');

    _newVoiceText = "Hello World";
    await _speak();

    lastWords = '${result.recognizedWords} - ${result.finalResult}';
    staticResponse = _newVoiceText;
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    this.level = level;
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    lastError = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    lastStatus = '$status';
  }
}
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/data_access/product_dao.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

import '../business_logic/product_bl.dart';

void main() => runApp(VocalAssistant());

class VocalAssistant extends StatefulWidget {
  @override
  _VocalAssistantState createState() => _VocalAssistantState();
}

enum TtsState { playing, stopped, paused, continued }

class _VocalAssistantState extends State<VocalAssistant> {

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
  List<LocaleName> _localeNames = [];
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

  @override
  void initState() {
    super.initState();

    requestForPermissions();
    initTts();
  }

  Future<void> requestForPermissions() async {
    if (await Permission.speech.request().isGranted) {
      print("Speech permission is granted.");
    }
    if (await Permission.microphone.request().isGranted) {
      print("Microphone permission is granted.");
    }
  }

  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getEngines();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
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
        print("#hello1");
        await flutterTts.speak(_newVoiceText);
        print("#hello2");
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech) {
      // _localeNames = await speech.locales();

      _localeNames.add(LocaleName('en_US', 'English'));
      _localeNames.add(LocaleName('de_DE', 'Deutsch'));

      // var systemLocale = await speech.systemLocale();
      var systemLocale;

      if (null != systemLocale) {
        _currentLocaleId = systemLocale.localeId;
      } else {
        _currentLocaleId = 'de_DE';
      }

      language = _currentLocaleId;
      flutterTts.setLanguage(language);
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    }

    // Welcome Text
    // Heartly Welcome to Bakery B
    _newVoiceText = "Weichardt-Brot: Herzlich Willkommen in der ersten Demeter-Vollkornbäckerei!";
    await _speak();

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Preisschild Vocal Assistant'),
        ),
        body: Column(children: [
          Center(
            child: Text(
              'Speech recognition available',
              style: TextStyle(fontSize: 22.0),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextButton(
                      child: Text('Initialize'),
                      onPressed: _hasSpeech ? null : initSpeechState,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextButton(
                      child: Text('Start'),
                      onPressed: !_hasSpeech || speech.isListening
                          ? null
                          : startListening,
                    ),
                    TextButton(
                      child: Text('Stop'),
                      onPressed: speech.isListening ? stopListening : null,
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: speech.isListening ? cancelListening : null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
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
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'Recognized Words',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).selectedRowColor,
                        child: Center(
                          child: Text(
                            lastWords,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Positioned.fill(
                      //   bottom: 10,
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Container(
                      //       width: 40,
                      //       height: 40,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         boxShadow: [
                      //           BoxShadow(
                      //               blurRadius: .26,
                      //               spreadRadius: level * 1.5,
                      //               color: Colors.black.withOpacity(.05))
                      //         ],
                      //         color: Colors.white,
                      //         borderRadius:
                      //         BorderRadius.all(Radius.circular(50)),
                      //       ),
                      //       child: IconButton(
                      //         icon: Icon(Icons.mic),
                      //         onPressed: () => null,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).selectedRowColor,
                        child: Center(
                          child: Text(
                            staticResponse,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Positioned.fill(
                      //   bottom: 10,
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Container(
                      //       width: 40,
                      //       height: 40,
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //         boxShadow: [
                      //           BoxShadow(
                      //               blurRadius: .26,
                      //               spreadRadius: level * 1.5,
                      //               color: Colors.black.withOpacity(.05))
                      //         ],
                      //         color: Colors.white,
                      //         borderRadius:
                      //         BorderRadius.all(Radius.circular(50)),
                      //       ),
                      //       child: IconButton(
                      //         icon: Icon(Icons.mic),
                      //         onPressed: () => null,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Column(
          //     children: <Widget>[
          //       Center(
          //         child: Text(
          //           'Error Status',
          //           style: TextStyle(fontSize: 22.0),
          //         ),
          //       ),
          //       Center(
          //         child: Text(lastError),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: speech.isListening
                  ? Text(
                "I'm listening...",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
                  : Text(
                'Not listening',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
      ),
    );
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
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    _speak();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  Future<String> generateResponse(String request, String locale) async {
    Translation translation;

    request = request.trim().toLowerCase();
    print("#blackdiamond request 1 $request");

    if (locale != 'en_US') {
      translation = await translator.translate(request, from: 'de', to: 'en');
      request = translation.toString().trim().toLowerCase();
      print("#blackdiamond request 2 $request");
      Map<String, String> replacements = Map<String, String>();
      String key;
      RegExp(r"(spel\w+\sbread)|(dark\w+\sbread)").allMatches(request).forEach((match) {
        key = request.substring(match.start, match.end).trim();
        print("#blackdiamond key: $key");
        replacements.putIfAbsent(key, () => "");
      });

      if (replacements.containsKey("spelled bread")) {
        replacements.update("spelled bread", (v) => v = "dinkelbrot" );
      }

      if (replacements.containsKey("dark bread")) {
        replacements.update("dark bread", (v) => v = "dinkelbrot" );
      }

      replacements.forEach((key, value) => request = request.replaceAll(key, value));
      print("#blackdiamond request $request");
    }

    String response = '';

    switch(request) {
      case "hello i want to buy bread": response = "Here are some breads: Brötchenkonfekt, Dinkelbrötchen, Doppelte, Kräuterbrötchen, Kaiserbrötchen, Ciabatta, Croissant.";
                                          break;

      case "please tell me dinkelbrot price": response = "Each Dinkelbrötchen price is 1 euro 30 cent";
                                                  break;

      case "please give 6 dinkelbrot":
      case "please give six dinkelbrot": response = "Okay 6 Dinkelbrötchen are selected, total price is 7 euro 80 cent. Do you want to pay by card or paypal?";
                                                      break;

      case "please tell me ciabatta price": response = "Each Ciabatta price is 1 euro 45 cent";
                                                  break;

      case "please give 6 ciabatta":
      case "please give six ciabatta": response = "Okay 6 Ciabatta are selected, total price is 8 euro 70 cent. Do you want to pay by card or paypal?";
                                        break;

      case "please tell me dinkelbrot and ciabatta price":  response = "Each Dinkelbrötchen price is 1 euro 30 cent and Each Ciabatta price is 1 euro 45 cent";
                                                              break;

      case "please give 6 dinkelbrot and 6 ciabatta":
      case "please give 6 dinkelbrot & 6 ciabatta":

      case "please give 6 dinkelbrot and six ciabatta":
      case "please give 6 dinkelbrot & six ciabatta":

      case "please give six dinkelbrot and 6 ciabatta":
      case "please give six dinkelbrot & 6 ciabatta":

      case "please give six dinkelbrot and six ciabatta":
      case "please give six dinkelbrot & six ciabatta": response = "Okay 6 Dinkelbrötchen and 6 Ciabatta are selected, total price is 16 euro 50 cent. Do you want to pay by card or paypal?";
                                                            break;

      case "credit card":
      case "creditcard":

      case "debitcard":
      case "debit card": response = "Please enter your card number and pin number";
                          break;
      case "pay pal":
      case "paypal": response = "Please enter your paypal username and password";
                      break;

      case "credit card one two and one four":
      case "credit card one two & one four":
      case "creditcard one two and one four":
      case "creditcard one two & one four":

      case "credit card 12 and 14":
      case "credit card one two and 14":
      case "credit card 12 and one four":

      case "credit card 12 & 14":
      case "credit card one two & 14":
      case "credit card 12 & one four":

      case "credit card 1 2 and 1 4":
      case "credit card one two and 1 4":
      case "credit card 1 2 and one four":

      case "credit card 1 2 & 1 4":
      case "credit card one two & 1 4":
      case "credit card 1 2 & one four":

      case "creditcard 12 and 14":
      case "creditcard one two and 14":
      case "creditcard 12 and one four":

      case "creditcard 12 & 14":
      case "creditcard one two & 14":
      case "creditcard 12 & one four":

      case "creditcard 1 2 and 1 4":
      case "creditcard one two and 1 4":
      case "creditcard 1 2 and one four":

      case "creditcard 1 2 & 1 4":
      case "creditcard one two & 1 4":
      case "creditcard 1 2 & one four":

      case "debit card one two and one four":
      case "debit card one two & one four":
      case "debitcard one two and one four":
      case "debitcard one two & one four":

      case "debit card 12 and 14":
      case "debit card one two and 14":
      case "debit card 12 and one four":

      case "debit card 12 & 14":
      case "debit card one two & 14":
      case "debit card 12 & one four":

      case "debit card 1 2 and 1 4":
      case "debit card one two and 1 4":
      case "debit card 1 2 and one four":

      case "debit card 1 2 & 1 4":
      case "debit card one two & 1 4":
      case "debit card 1 2 & one four":

      case "debitcard 12 and 14":
      case "debitcard one two and 14":
      case "debitcard 12 and one four":

      case "debitcard 12 & 14":
      case "debitcard one two & 14":
      case "debitcard 12 & one four":

      case "debitcard 1 2 and 1 4":
      case "debitcard one two and 1 4":
      case "debitcard 1 2 and one four":

      case "debitcard 1 2 & 1 4":
      case "debitcard one two & 1 4":
      case "debitcard 1 2 & one four":

      case "paypal blackdiamond and 14":
      case "paypal black diamond and 14":
      case "paypal blackdiamond and 1 4":
      case "paypal black diamond and 1 4":

      case "pay pal blackdiamond and 14":
      case "pay pal black diamond and 14":
      case "pay pal blackdiamond and 1 4":
      case "pay pal black diamond and 1 4":

      case "paypal blackdiamond & 14":
      case "paypal black diamond & 14":
      case "paypal blackdiamond & 1 4":
      case "paypal black diamond & 1 4":

      case "pay pal blackdiamond & 14":
      case "pay pal black diamond & 14":
      case "pay pal blackdiamond & 1 4":
      case "pay pal black diamond & 1 4":

      case "paypal blackdiamond & one four":
      case "paypal blackdiamond & one 4":
      case "paypal blackdiamond & 1 four":

      case "paypal black diamond & one four":
      case "paypal black diamond & one 4":
      case "paypal black diamond & 1 four":

      case "pay pal blackdiamond & one four":
      case "pay pal blackdiamond & one 4":
      case "pay pal blackdiamond & 1 four":

      case "pay pal black diamond & one four":
      case "pay pal black diamond & one 4":
      case "pay pal black diamond & 1 four":

      case "paypal blackdiamond and one four":
      case "paypal blackdiamond and one 4":
      case "paypal blackdiamond and 1 four":

      case "paypal black diamond and one four":
      case "paypal black diamond and one 4":
      case "paypal black diamond and 1 four":

      case "pay pal blackdiamond and one four":
      case "pay pal blackdiamond and one 4":
      case "pay pal blackdiamond and 1 four":

      case "pay pal black diamond and one four":
      case "pay pal black diamond and one 4":
      case "pay pal black diamond and 1 four": response = "Thank you for payment, here are your breads. Have a nice day.";
                                               break;
    }

    if (locale != 'en_US' && response.isNotEmpty) {
      translation = await translator.translate(response, from: 'en', to: 'de');
      response = translation.toString();
      print("#blackdiamond response $response");
    }

    return Future.value(response);
  }

  Future<void> resultListener(SpeechRecognitionResult result) async {
    ++resultListened;
    print('Result listener $resultListened');

    _newVoiceText = await generateResponse(result.recognizedWords, _currentLocaleId);
    await _speak();

    setState(() {
      lastWords = '${result.recognizedWords} - ${result.finalResult}';
      staticResponse = _newVoiceText;
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
      //TODO make generic by creating function
      language = _currentLocaleId;
      flutterTts.setLanguage(language);
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    });
    print(selectedVal);
  }
}
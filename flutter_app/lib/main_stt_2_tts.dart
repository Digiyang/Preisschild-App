import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/data_access/product_dao.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

import 'business_logic/product_bl.dart';

void main() => runApp(VocalAssistant());

class VocalAssistant extends StatefulWidget {
  @override
  _VocalAssistantState createState() => _VocalAssistantState();
}

enum TtsState { playing, stopped, paused, continued }

class _VocalAssistantState extends State<VocalAssistant> {
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
  double volume = 0.6;
  double pitch = 1.0;
  double rate = 0.36;
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
    initTts();
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
        await flutterTts.speak(_newVoiceText);
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
      _localeNames = await speech.locales();
      _localeNames.add(LocaleName('en_US', 'English'));
      _localeNames.add(LocaleName('de_DE', 'Deutsch'));

      var systemLocale = await speech.systemLocale();
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
    _newVoiceText = "Herzlich Willkommen in der Bäckerei B";
    _speak();

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

  Future<void> resultListener(SpeechRecognitionResult result) async {
    ++resultListened;
    print('Result listener $resultListened');

    // if (result.recognizedWords.toLowerCase() == "product list") {
    //   print("#blackdiamond ${result.recognizedWords}");
    //   List<ProductDao> products = await ProductBL().get_all_products();
    //   print("#blackdiamond " + products.length.toString());
    // }

    // _newVoiceText = result.recognizedWords;

    _newVoiceText = _currentLocaleId == "en_US" ? "Here are breads you might like:" : "Hier sind Brote, die Ihnen gefallen könnten:";
    _speak();

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
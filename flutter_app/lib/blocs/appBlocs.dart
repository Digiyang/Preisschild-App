import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/Services/geolocation.dart';
import 'package:flutter_app/Services/placesCall.dart';
import 'package:flutter_app/template/places.dart';
import 'package:flutter_app/template/where.dart';
import 'package:geolocator/geolocator.dart';

// ignore: camel_case_types
class AppBlocs with ChangeNotifier {
  final geo = Geolocation();
  final services = PlacesCall();

  Position current;
  List<Places> searchResponse = [];
  StreamController<Somewhere> selection = StreamController<Somewhere>();

  AppBlocs() {
    setLocation();
  }

  setLocation() async {
    current = await geo.showCurrentLocation();
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  searching(String term) async {
    searchResponse = await services.autocomplete(term);
    notifyListeners();
  }

  setSelection(String placeId) async {
    selection.add(await services.getWhere(placeId));
    searchResponse = null;
    notifyListeners();
  }

  @override
  void dispose() {
    selection.close();
    super.dispose();
  }
}

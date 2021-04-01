import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/Services/geolocation.dart';
import 'package:flutter_app/Services/pin.dart';
import 'package:flutter_app/Services/placesCall.dart';
import 'package:flutter_app/template/calibration.dart';
import 'package:flutter_app/template/locate.dart';
import 'package:flutter_app/template/places.dart';
import 'package:flutter_app/template/where.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: camel_case_types
class AppBlocs with ChangeNotifier {
  final geo = Geolocation();
  final services = PlacesCall();
  final pinService = Pin();

  Position current;
  List<Places> searchResponse = [];
  StreamController<Somewhere> selection =
      StreamController<Somewhere>.broadcast();
  StreamController<LatLngBounds> bounds =
      StreamController<LatLngBounds>.broadcast();
  Somewhere staticArea;
  String area;
  List<Marker> pins = List<Marker>();

  AppBlocs() {
    setLocation();
  }

  setLocation() async {
    current = await geo.showCurrentLocation();
    staticArea = Somewhere(
      name: null,
      calibration: Calibration(
        location: Location(lat: current.latitude, lng: current.longitude),
      ),
    );

    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  searching(String term) async {
    searchResponse = await services.autocomplete(term);
    notifyListeners();
  }

  setSelection(String placeId) async {
    var aw = await services.getWhere(placeId);
    selection.add(aw);
    staticArea = aw;
    searchResponse = null;
    notifyListeners();
  }

  toggleArea(String value, bool choice) async {
    if (choice) {
      area = value;
    } else {
      area = null;
    }

    if (area != null) {
      var areas = await services.getArea(staticArea.calibration.location.lat,
          staticArea.calibration.location.lng, area);
      pins = [];

      if (areas.length > 0) {
        var newPin = pinService.initPin(areas[0]);
        pins.add(newPin);
      }

      var locationPin = pinService.initPin(staticArea);
      pins.add(locationPin);

      var bnds = pinService.bounds(Set<Marker>.of(pins));
      bounds.add(bnds);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    selection.close();
    super.dispose();
  }
}

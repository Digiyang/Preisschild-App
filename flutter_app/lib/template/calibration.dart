import 'package:flutter_app/template/locate.dart';

import 'package:flutter_app/template/locate.dart';

class Calibration {
  final Location location;

  Calibration({this.location});

  factory Calibration.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Calibration(location: Location.fromJson(parsedJson['location']));
  }
}

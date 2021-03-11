import 'package:flutter_app/template/calibration.dart';

class Somewhere {
  final Calibration calibration;
  final String name, vicinity;

  Somewhere({this.calibration, this.name, this.vicinity});

  factory Somewhere.fromJson(Map<String, dynamic> parsedJson) {
    return Somewhere(
        calibration: Calibration.fromJson(parsedJson['geometry']),
        name: parsedJson['formatted_address'],
        vicinity: parsedJson['vicinity']);
  }
}

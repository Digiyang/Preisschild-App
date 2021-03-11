import 'package:geolocator/geolocator.dart';

class Geolocation {
  Future<Position> showCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

import 'package:flutter_app/template/where.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pin {
  LatLngBounds bounds(Set<Marker> pins) {
    if (pins == null || pins.isEmpty) return null;
    return setBounds(pins.map((m) => m.position).toList());
  }

  LatLngBounds setBounds(List<LatLng> _pin) {
    final swLatitude = _pin
        .map((p) => p.latitude)
        .reduce((value, element) => value < element ? value : element);
    final swLongitude = _pin
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final neLatitude = _pin
        .map((p) => p.latitude)
        .reduce((value, element) => value < element ? value : element);
    final neLongitude = _pin
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    return LatLngBounds(
        southwest: LatLng(swLatitude, swLongitude),
        northeast: LatLng(neLatitude, neLongitude));
  }

  Marker initPin(Somewhere where) {
    var id = where.name;

    return Marker(
        markerId: MarkerId(id),
        draggable: false,
        infoWindow: InfoWindow(title: where.name, snippet: where.vicinity),
        position: LatLng(
            where.calibration.location.lat, where.calibration.location.lng));
  }
}

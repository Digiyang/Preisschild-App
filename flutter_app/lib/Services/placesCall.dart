import 'dart:convert' as convert;

import 'package:flutter_app/template/places.dart';
import 'package:flutter_app/template/where.dart';
import 'package:http/http.dart' as http;

class PlacesCall {
  final apiKey = 'AIzaSyB2G3zsHfwXxzvrR175Htiz-7c_AI8IXTE';

  Future<List<Places>> autocomplete(String search) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$apiKey');
    var request = await http.get(url);
    var json = convert.jsonDecode(request.body);
    var jsonReq = json['predictions'] as List;
    return jsonReq.map((place) => Places.fromJson(place)).toList();
  }

  Future<Somewhere> getWhere(String placeId) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?key=$apiKey&place_id=$placeId');
    var request = await http.get(url);
    var json = convert.jsonDecode(request.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Somewhere.fromJson(jsonResult);
  }
}

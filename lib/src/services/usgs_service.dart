import 'package:geolocation/geolocation.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:meteo_quake/src/models/sismo_model.dart';

class UsgsService {
  getSismos() async {
    final String url =
        "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        List _data = parsedJson['features'];
        List _result = List();
        for (int i = 0; i < _data.length; i++) {
          _result.add(_data[i]);
        }
        print(_result[0]);
        return _result.toList();
      } else {
        return List<Feature>();
      }
    } catch (e) {
      return List<Feature>();
    }
  }

  Future<LocationResult> getLocation() async {
    LocationResult result = await Geolocation.lastKnownLocation();
    return result;
  }
}

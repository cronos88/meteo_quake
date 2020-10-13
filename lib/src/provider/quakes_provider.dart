import 'package:flutter/material.dart';
import 'package:meteo_quake/src/models/sismo_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class QuakesProvider with ChangeNotifier {
  List<dynamic> _sismos;

  //* Getter
  List<dynamic> get sismos => _sismos;

  //* Setter
  void setSismos(List<dynamic> sismos) {
    _sismos = sismos;
    notifyListeners();
    print("Nuevo valor de sismos: $_sismos");
  }

  //* Methods
  Future<void> getSismos() async {
    print("Metodo getSismos");
    final String url =
        "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('statuscode 200');
        final parsedJson = json.decode(response.body);
        List _data = parsedJson['features'];
        List _result = List();
        for (int i = 0; i < _data.length; i++) {
          _result.add(_data[i]);
        }
        // _sismos = _result.toList();
        setSismos(_result.toList());
        print("Largo de _sismos ${_sismos.length}");
      } else {
        _sismos = [];
      }
    } catch (e) {
      return List<Feature>();
    }
  }
}

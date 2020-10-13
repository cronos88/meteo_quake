import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';

class LocationProvider with ChangeNotifier {
  double _latitude;
  double _longitude;

  //* Getters
  double get latitude => _latitude;
  double get longitude => _longitude;

  //* Setters
  void setLatitude(double lat) {
    _latitude = lat;
    // notifyListeners();
  }

  void setLongitude(double lng) {
    _longitude = lng;
    // notifyListeners();
  }

  //* methods
  Future<void> getLocation() async {
    LocationResult result = await Geolocation.lastKnownLocation();
    if (result != null) {
      _latitude = result.location.latitude;
      _longitude = result.location.longitude;
      notifyListeners();
    } else {
      _latitude = 0.0;
      _longitude = 0.0;
      notifyListeners();
    }
  }
}

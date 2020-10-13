import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:meteo_quake/src/provider/location_provider.dart';
import 'package:meteo_quake/src/provider/quakes_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:ui' as ui;

class ListaSismos extends StatefulWidget {
  @override
  _ListaSismosState createState() => _ListaSismosState();
}

class _ListaSismosState extends State<ListaSismos> {
  @override
  void initState() {
    super.initState();
    print("Init State");
    QuakesProvider().getSismos();
  }

  @override
  Widget build(BuildContext context) {
    final QuakesProvider quakesProvider = Provider.of<QuakesProvider>(context);
    final quakes = (quakesProvider.sismos != null) ? quakesProvider.sismos : [];
    print("Cantidad: ${quakesProvider.sismos}");
    return Scaffold(
        body: Container(
      child: (quakes.length > 0)
          ? ListView.builder(
              itemCount: quakes.length,
              itemBuilder: (BuildContext context, int index) {
                return _quakeCard(
                    quakes: quakes, index: index, context: context);
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }

  Widget _quakeCard({quakes, index, context}) {
    final LocationProvider locationProvider =
        Provider.of<LocationProvider>(context);
    final Distance distance = Distance();

    if (quakes != null) {
      var properties = quakes[index]['properties'];
      var geometry = quakes[index]['geometry'];

      var place = properties['place'];
      var magnitude = properties['mag'].toStringAsFixed(1);
      // var magType = properties['magType'];
      var prof = geometry['coordinates'][2];
      var lat = geometry['coordinates'][1];
      var lng = geometry['coordinates'][0];
      var date =
          DateTime.fromMillisecondsSinceEpoch(properties['time']).toLocal();
      var _syslng =
          ui.window.locale.languageCode; //Averiguar el idioma del dispositivo

      var myLat = (locationProvider != null) ? locationProvider.latitude : 0.0;
      var myLng = (locationProvider != null) ? locationProvider.longitude : 0.0;

      final double km = distance.as(
          LengthUnit.Kilometer, LatLng(myLat, myLng), LatLng(lat, lng));
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      place,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    magnitude,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.clock),
                  SizedBox(width: 10),
                  Text(date.toString().substring(11, 19)),
                  SizedBox(width: 10),
                  Text(timeago.format(date, locale: _syslng))
                ],
              ),
              Row(
                children: <Widget>[
                  // FaIcon(FontAwesomeIcons.caretDown),
                  Text('Profundidad: '),
                  SizedBox(width: 10),
                  Text('$prof km'),
                ],
              ),
              Row(
                children: <Widget>[Text('${km.toInt()} km de tu ubicación')],
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

// * FIN

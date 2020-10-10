import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocation/geolocation.dart';
import 'package:latlong/latlong.dart';
import 'package:meteo_quake/src/services/usgs_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:ui' as ui;

class ListaSismos extends StatefulWidget {
  @override
  _ListaSismosState createState() => _ListaSismosState();
}

class _ListaSismosState extends State<ListaSismos> with WidgetsBindingObserver {
  final UsgsService usgsService = UsgsService();
  final Distance distance = Distance();
  List<dynamic> _sismos;
  LocationResult _location;

  @override
  void initState() {
    super.initState();
    usgsService.getSismos().then((sismo) {
      setState(() {
        _sismos = sismo;
      });
      print('tamano: ${_sismos.length}');
    });
    usgsService.getLocation().then((loc) {
      setState(() {
        _location = loc;
      });
      print(_location);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      usgsService.getSismos().then((sismo) {
        setState(() {
          _sismos = sismo;
        });
        print('tamano: ${_sismos.length}');
      });
      print('resumed');
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<dynamic> sismo;
    return Scaffold(
      appBar: AppBar(
        title: Text('Meteo Quake'),
      ),
      body: Container(
        margin: EdgeInsets.all(6),
        color: Colors.white,
        child: ListView.builder(
          itemCount: (_sismos != null) ? _sismos.length : 1,
          itemBuilder: (BuildContext context, int index) {
            if (_sismos != null) {
              var properties = _sismos[index]['properties'];
              var geometry = _sismos[index]['geometry'];

              var place = properties['place'];
              var magnitude = properties['mag'].toStringAsFixed(1);
              var magType = properties['magType'];
              var prof = geometry['coordinates'][2];
              var lat = geometry['coordinates'][1];
              var lng = geometry['coordinates'][0];
              var date = DateTime.fromMillisecondsSinceEpoch(properties['time'])
                  .toLocal();
              var _syslng = ui.window.locale
                  .languageCode; //Averiguar el idioma del dispositivo

              var myLat =
                  (_location != null) ? _location.location.latitude : 0.0;
              var myLng =
                  (_location != null) ? _location.location.longitude : 0.0;

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
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          /* Text(
                            magType,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ) */
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
                        children: <Widget>[
                          Text('${km.toInt()} km de tu ubicación')
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

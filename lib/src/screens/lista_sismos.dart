import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocation/geolocation.dart';
import 'package:latlong/latlong.dart';
import 'package:meteo_quake/src/models/sismo_model.dart';
import 'package:meteo_quake/src/screens/mapa_sismo.dart';
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
            final SismoModel sismo1 = _sismos[index];
            Color magColor;
            double magValue = sismo1.magnitude;
            if (magValue < 4.0) {
              magColor = Colors.green;
            } else if (magValue >= 4.0 && magValue < 6.0) {
              magColor = Colors.red;
            } else if (magValue > 6.0) {
              magColor = Colors.purple;
            }
            // return sismoItem(sismo1, magColor);
            return Text('hols');
          },
        ),
      ),
    );
  }

  Widget sismoItem(sismo, Color magColor) {
    final Distance distance = Distance();
    if (sismo != null) {
      var lat = sismo.latitude;
      var lng = sismo.longitude;
      var date = DateTime.fromMillisecondsSinceEpoch(sismo.time).toLocal();
      var _syslng = ui.window.locale.languageCode;
      var myLat = (_location != null) ? _location.location.latitude : 0.0;
      var myLng = (_location != null) ? _location.location.longitude : 0.0;
      final double km = distance.as(
          LengthUnit.Kilometer, LatLng(myLat, myLng), LatLng(lat, lng));

      return GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapaSismo())),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          color: Colors.grey[200],
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                      sismo.place,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      sismo.magnitude.toStringAsFixed(1),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: magColor),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.clock,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 15),
                    Text(date.toString().substring(11, 19)),
                    SizedBox(width: 10),
                    Text(timeago.format(date, locale: _syslng))
                  ],
                ),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.caretDown,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text('Profundidad: '),
                    SizedBox(width: 10),
                    Text('${sismo.depth} km'),
                  ],
                ),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.ruler,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Text('${km.toInt()} km de tu ubicación'),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

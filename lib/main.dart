import 'package:flutter/material.dart';
import 'package:meteo_quake/src/provider/location_provider.dart';
import 'package:meteo_quake/src/provider/quakes_provider.dart';
import 'package:meteo_quake/src/screens/lista_sismos.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => QuakesProvider()),
      ],
      child: MaterialApp(
        title: 'Material App',
        home: ListaSismos(),
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meteo_quake/src/screens/lista_sismos.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: ListaSismos(),
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}

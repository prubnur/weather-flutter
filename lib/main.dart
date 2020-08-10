import 'package:flutter/material.dart';
import 'package:weather/ui/weather.dart';

void main () {
  runApp(
      new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Weather",
        home: new Weather(),
      ));
}
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/home.dart';
import 'package:tracker_covid_v1/screen/startscreen.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartScreen(key: key),
    );
  }
}

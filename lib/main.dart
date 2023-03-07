import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/home.dart';
import 'package:tracker_covid_v1/screen/startscreen.dart';
import 'package:tracker_covid_v1/screen/welcome.dart';

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
          primarySwatch: Colors.brown, backgroundColor: Colors.grey.shade300),
      home: const StartScreen(),
    );
  }
}

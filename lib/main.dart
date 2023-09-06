import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:tracker_covid_v1/screen/startscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter demo',
      theme: ThemeData(),
      home: StartScreen(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:tracker_covid_v1/screen/startscreen.dart';

import 'provider/provider_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return CheckProvider();
          }),
          ],
    child: const MaterialApp(
      localizationsDelegates:  [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: 
       [
        // Locale('en', 'US'), // English
        Locale('th', 'TH'), // Thai
      ],
      home: StartScreen(),
    ));
  }
}

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tracker_covid_v1/screen/home.dart';
import 'package:tracker_covid_v1/screen/login.dart';
import 'package:tracker_covid_v1/screen/map.dart';
import 'package:tracker_covid_v1/theme/colors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAuth_auth = FirebaseAuth.instance;

// ignore: must_be_immutable
class WelcomeScreen extends StatelessWidget {
  // ignore: non_constant_identifier_names
  String _email = '';
  WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MapSample();
                }));
              },
              icon: const Icon(Icons.near_me))
        ],
      ),
      body: Center(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    FirebaseAuth_auth.currentUser!.email!,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        await _auth.signOut().then((value) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: ((context) {
                            return const LoginScreen();
                          })));
                        });
                      },
                      icon: const Icon(Icons.logout),
                      label: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("ออกจากระบบ")))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

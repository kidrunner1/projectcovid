import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:tracker_covid_v1/screen/home.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAuth_auth = FirebaseAuth.instance;

class WelcomeScreen extends StatelessWidget {
  // ignore: non_constant_identifier_names
  String _email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Wellcome"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  FirebaseAuth_auth.currentUser!.email!,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await _auth.signOut().then((value) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: ((context) {
                          return HomeScreen();
                        })));
                      });
                    },
                    child: Text("ออกจากระบบ"))
              ],
            ),
          )),
    );
  }
}

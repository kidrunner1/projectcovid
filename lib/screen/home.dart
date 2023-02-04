import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tracker_covid_v1/screen/login.dart';
import 'package:tracker_covid_v1/screen/register.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tracker-Covid19_v1.0.0",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Column(children: [
            Image.asset("assets/images/unnamed.png"),
            SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      onPressed: (() {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const RegisterScreen();
                        }));
                      }),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)))),
                      icon: const Icon(Icons.add), //icons_add_buttons
                      // ignore: prefer_const_constructors
                      label: Text(
                        "สร้างบัญชีผู้ใช้",
                        style: const TextStyle(fontSize: 24),
                      )),
                )),
            SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      onPressed: (() {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ));
                      }),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)))),
                      icon: const Icon(Icons.login),
                      // ignore: prefer_const_constructors
                      label: Text(
                        "เข้าสู้ระบบ",
                        style: const TextStyle(fontSize: 24),
                      )),
                ))
          ]),
        ),
      ),
    );
  }
}

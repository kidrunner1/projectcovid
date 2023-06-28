import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tracker_covid_v1/screen/home.dart';
import 'package:tracker_covid_v1/screen/welcome.dart';

import 'map.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/page.png"),
              ),
              const Text(
                "ระบบจัดการสถานะการณ์ COVID-19",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  CupertinoIcons.arrow_right,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const HomeScreen();
                    },
                  ));
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20.0),
                    backgroundColor: Colors.pinkAccent,
                    fixedSize: const Size(500, 80),
                    textStyle: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    elevation: 15,
                    shadowColor: Colors.pink,
                    shape: const StadiumBorder()),
                label: const Text('เริ่มแอปพลิเคชั่น'),
              ),
            ]),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

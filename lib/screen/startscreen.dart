import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
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
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(32),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 30),
                          backgroundColor: Colors.red.shade300,
                          minimumSize: const Size.fromHeight(72),
                          shape: const StadiumBorder()),
                      child: const Text('เริ่มแอปพลิเคชั่น'),
                      onPressed: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const HomeScreen();
                        }));
                      },
                    ),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

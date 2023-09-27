import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'home.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  double slidePosition = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: SpinKitThreeBounce(
                color: Colors.red.shade300,
                size: 50.0,
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 220,
                      ),
                    ),
                    Text(
                      "  COVID-19\nSave Health",
                      style: GoogleFonts.prompt(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(32),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Text(
                            'เลื่อนเพื่อเปิด',
                            style: GoogleFonts.prompt(
                                color: Colors.black54, fontSize: 15),
                          ),
                        ),
                        AnimatedPositioned(
                          left: slidePosition,
                          duration: const Duration(milliseconds: 200),
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              setState(() {
                                slidePosition += details.delta.dx;
                                if (slidePosition < 0) slidePosition = 0;
                                if (slidePosition >
                                    MediaQuery.of(context).size.width * 0.8 -
                                        100) {
                                  slidePosition = 0;
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const HomeScreen();
                                    }));
                                  });
                                }
                              });
                            },
                            child: Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.red.shade500,
                                    Colors.red.shade300
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
      backgroundColor: Colors.pink[50],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:tracker_covid_v1/screen/login_screen.dart';
import 'package:tracker_covid_v1/screen/register.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/page.png"),
                    ),
                    const Text(
                      'แอปพลิเคชันติดตามและ ประเมินผู้ที่มีความเสี่ยงโควิด-19',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),

                    // Register ID
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(10.10),
                                child: ElevatedButton(
                                    onPressed: (() {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return RegisterScreen();
                                      }));
                                    }),
                                    style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        backgroundColor: Colors.red.shade300),
                                    //icons_add_buttons
                                    // ignore: prefer_const_constructors
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        "สร้างบัญชีผู้ใช้",
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    )),
                              )),
                          // หน้าเข้าสู้ระบบ
                          SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: (() {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    }),
                                    style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        backgroundColor: Colors.red.shade300),

                                    // ignore: prefer_const_constructors
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text("เข้าสู่ระบบ",
                                          style: TextStyle(fontSize: 24)),
                                    )),
                              ))
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

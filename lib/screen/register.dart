import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:tracker_covid_v1/model/profile.dart';
import 'package:tracker_covid_v1/screen/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fromKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '', name: '', lastname: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(child: Text("${snapshot.error}")),
            );
          } //ตรวจสอบ Error firebase
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(title: const Text("สร้างบัญชีผู้ใช้")),
              // ignore: avoid_unnecessary_containers
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: fromKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Image.asset("assest/images/"),
                          const Text("อีเมล",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                          TextFormField(
                            validator: MultiValidator([
                              EmailValidator(
                                  errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                              RequiredValidator(errorText: "กรุณากรอก-อีเมล")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (email) {
                              profile.email = email!;
                            },
                          ),
                          const SizedBox(height: 15),
                          const Text("รหัสผ่าน",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณากรอก-รหัสผ่าน"),
                            obscureText: true,
                            onSaved: (password) {
                              profile.password = password!;
                            }, // ปิดรหัสผ่าน
                          ),
                          const SizedBox(height: 15),
                          const Text("ชื่อ",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                          TextFormField(
                            validator:
                                RequiredValidator(errorText: "กรุณากรอก-ชื่อ"),
                            onSaved: (name) {
                              profile.name = name!;
                            },
                          ),
                          const SizedBox(height: 15),
                          const Text("นามสกุล",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณากรอก-นามสกุล"),
                            onSaved: (lastname) {
                              profile.lastname = lastname!;
                            },
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text("ลงทะเบียน",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                              onPressed: () async {
                                if (fromKey.currentState!.validate()) {
                                  fromKey.currentState!.save();
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: profile.email,
                                      password: profile.password,
                                    )
                                        .then((value) {
                                      fromKey.currentState!.reset();
                                      Fluttertoast.showToast(
                                          msg: "สร้างบัญชีผู้ใช้เรียบร้อยแล้ว",
                                          gravity: ToastGravity.TOP);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const HomeScreen();
                                      }));
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    print(e.code);
                                    var message;
                                    if (e.code == 'email-already-in-use') {
                                      message = "อีเมลนี้ มีผู้ใช้แล้ว";
                                    } else if (e.code == 'weak-password') {
                                      message =
                                          "ความยาวรหัสผ่านต้อง 6 ตัวอักษรขึ้นไป";
                                    } else {
                                      message = e.message;
                                    }
                                    Fluttertoast.showToast(
                                        msg: message,
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.white, // สี backgroun
            );
          }
          // ignore: prefer_const_constructors
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        });
  }
}

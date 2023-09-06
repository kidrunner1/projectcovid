import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:tracker_covid_v1/screen/register.dart';
import 'package:tracker_covid_v1/screen/reset_page.dart';
import 'package:tracker_covid_v1/screen/main_page.dart';

import '../model/profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final fromKey = GlobalKey<FormState>();
  Profile profile = Profile(
      email: '', password: '', name: '', lastname: '', number: '', id: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(child: Text("${snapshot.error}")),
            );
          } //ตรวจสอบ Error firebase
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: fromKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(fontSize: 50),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // อีเมล TextField
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: MultiValidator([
                                EmailValidator(
                                  errorText: "รูปแบบอีเมลไม่ถูกต้อง",
                                ),
                                RequiredValidator(errorText: "กรุณากรอก-อีเมล"),
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: 'อีเมล',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onSaved: (email) {
                                profile.email = email!;
                              },
                            ),
                          ),

                          // รหัสผ่าน textfield
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: RequiredValidator(
                                  errorText: "กรุณากรอก-รหัสผ่าน"),
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'รหัสผ่าน',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onSaved: (password) {
                                profile.password = password!;
                              }, // ปิดรหัสผ่าน
                            ),
                          ),

                          //Password Reset
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text('ลืมรหัสผ่าน ?  '),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const ResetPassword();
                                        }));
                                      },
                                      child: const Text(
                                        'กดตรงนี้ ',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          //Login button
                          const SizedBox(height: 10),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.20),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (fromKey.currentState!.validate()) {
                                        fromKey.currentState!.save();
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: profile.email,
                                                  password: profile.password)
                                              .then((value) {
                                            fromKey.currentState!.reset();
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return const MyHomePage(
                                                  title: '',
                                                );
                                              },
                                            ));
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.message!,
                                              gravity: ToastGravity.CENTER);
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        backgroundColor: Colors.red.shade300,
                                        minimumSize: Size(200, 50)),
                                    child: const Text(
                                      "ลงชื่อเข้าใช้",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          // ลงทะเบียน
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('ยังไม่มีบัญชีใช่ไหม?   '),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return RegisterScreen();
                                        }));
                                      },
                                      child: const Text(
                                        'ลงทะเบียน',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Admin page
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.pink.shade50, // สี backgroun
            );
          }
          // ignore: prefer_const_constructors
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        });
  }
}

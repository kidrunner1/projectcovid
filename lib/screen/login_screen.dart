import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:tracker_covid_v1/screen/register.dart';
import 'package:tracker_covid_v1/screen/reset_page.dart';
import 'package:tracker_covid_v1/screen/main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final fromKey = GlobalKey<FormState>();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: Center(child: Text("${snapshot.error}")),
            );
          }

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
                            child: Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(fontSize: 50),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Email field
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _emailController,
                              validator: MultiValidator([
                                EmailValidator(
                                    errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                                RequiredValidator(errorText: "กรุณากรอก-อีเมล"),
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'อีเมล',
                                hintText: 'อีเมล',
                                prefixIcon: const Icon(Icons.mail),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          // Password field
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _passwordController,
                              validator: RequiredValidator(
                                  errorText: "กรุณากรอก-รหัสผ่าน"),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'รหัสผ่าน',
                                hintText: 'รหัสผ่าน',
                                prefixIcon: const Icon(Icons.key),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          // Password Reset
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text('ลืมรหัสผ่าน ?  '),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const ResetPassword();
                                    }));
                                  },
                                  child: const Text(
                                    'กดตรงนี้ ',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Login button
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.20),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (fromKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true; // Start loading
                                  });

                                  fromKey.currentState!.save();
                                  try {
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: _emailController.text
                                                    .trim(),
                                                password: _passwordController
                                                    .text
                                                    .trim());

                                    if (userCredential.user != null) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyHomePage(
                                            user: userCredential.user,
                                            title: '',
                                          ),
                                        ),
                                      );
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    Fluttertoast.showToast(
                                        msg: e.message!,
                                        gravity: ToastGravity.CENTER);
                                  } finally {
                                    setState(() {
                                      _isLoading = false; // Stop loading
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.red.shade300,
                                minimumSize: const Size(200, 50),
                              ),
                              child: _isLoading
                                  ? const SpinKitFadingCircle(
                                      color: Colors.white,
                                      size: 24.0,
                                    )
                                  : const Text(
                                      "ลงชื่อเข้าใช้",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,color: Colors.white
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Register button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('ยังไม่มีบัญชีใช่ไหม?   '),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return RegisterScreen();
                                    }));
                                  },
                                  child: const Text(
                                    'ลงทะเบียน',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.pink.shade50,
            );
          }
          // ignore: prefer_const_constructors
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

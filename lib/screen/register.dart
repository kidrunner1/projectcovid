import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:tracker_covid_v1/screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('users');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final _phonenumberController = TextEditingController();

  final fromKey = GlobalKey<FormState>();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
//add user details
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phonenumberController.dispose();
    super.dispose();
  }

  Future<void> addUserDetails(String uid, String firstName, String lastName,
      String email, String phoneNumber) async {
    // Getting a reference to the users collection and the specific document with the UID
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return await users
        .doc(uid)
        .set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

//password Confirm
  bool passwordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmpasswordController.text.trim();
  }

  Future<void> register(String uid) async {
    if (!passwordConfirmed()) {
      print("Passwords do not match!");
      return;
    }
    try {
      // If registration successful, add user details to Firestore using the provided UID
      await addUserDetails(
        uid,
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _phonenumberController.text.trim(),
      );
      print("Registration successful for UID: $uid");
    } catch (e) {
      print("Error during registration: $e");
    }
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    'ลงทะเบียนเลย',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          // email text
                          TextFormField(
                            controller: _emailController,
                            validator: MultiValidator([
                              EmailValidator(
                                  errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                              RequiredValidator(errorText: "กรุณากรอก-อีเมล")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: 'อี เ ม ล',
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                          ),

                          //password textfield
                          const SizedBox(height: 15),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            validator: RequiredValidator(
                                errorText: "กรุณากรอก-รหัสผ่าน"),
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'ร หั ส ผ่ า น',
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            // ปิดรหัสผ่าน
                          ),
                          const SizedBox(height: 15),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          TextFormField(
                            controller: _confirmpasswordController,
                            validator: RequiredValidator(
                                errorText: "กรุณากรอก-รหัสผ่าน"),
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'ยื น ยั น ร หั ส ผ่ า น',
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            // ปิดรหัสผ่าน
                          ),

                          // firstname textfield
                          const SizedBox(height: 15),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          TextFormField(
                            controller: _firstNameController,
                            validator:
                                RequiredValidator(errorText: "กรุณากรอก-ชื่อ"),
                            decoration: InputDecoration(
                                hintText: 'ชื่ อ',
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                          ),

                          // lastname textfield
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          TextFormField(
                            controller: _lastNameController,
                            validator: RequiredValidator(
                                errorText: "กรุณากรอก-นามสกุล"),
                            decoration: InputDecoration(
                                hintText: 'น า ม ส กุ ล',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                          ),

                          // phone textfield
                          const SizedBox(
                            height: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          TextFormField(
                            controller: _phonenumberController,
                            validator: RequiredValidator(
                                errorText: "กรุณากรอก-เบอร์โทร"),
                            decoration: InputDecoration(
                                hintText: 'เ บ อ ร์ โ ท ร',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                          ),

                          // สมัครสมาชิค
                          const SizedBox(height: 15),
                          const Padding(padding: EdgeInsets.all(8.0)),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (fromKey.currentState!.validate()) {
                                  if (_passwordController.text !=
                                      _confirmpasswordController.text) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน",
                                        gravity: ToastGravity.CENTER);
                                    return;
                                  }

                                  try {
                                    // authenticate user
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );

                                    // Call the register function
                                    await register(userCredential.user!.uid);

                                    // Get UID of the authenticated user
                                    String uid = userCredential.user!.uid;

                                    // If user authentication is successful, then add user details to Firestore using the UID
                                    await addUserDetails(
                                      uid,
                                      _firstNameController.text.trim(),
                                      _lastNameController.text.trim(),
                                      _emailController.text.trim(),
                                      _phonenumberController.text.trim(),
                                    );

                                    Fluttertoast.showToast(
                                        msg: "สร้างบัญชีผู้ใช้เรียบร้อยแล้ว",
                                        gravity: ToastGravity.TOP);

                                    // Navigate to LoginScreen after successful registration
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  } on FirebaseAuthException catch (e) {
                                    var message;

                                    if (e.code == 'email-already-in-use') {
                                      message = "อีเมลนี้ มีผู้ใช้แล้ว";
                                    } else if (e.code == 'weak-password') {
                                      message =
                                          "ความยาวรหัสผ่านต้อง 6 ตัวอักษรขึ้นไป";
                                    } else {
                                      message =
                                          e.message ?? 'An error occurred.';
                                    }
                                    Fluttertoast.showToast(
                                        msg: message,
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8.0),
                                  shape: const StadiumBorder(),
                                  backgroundColor: Colors.red.shade300),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("ล ง ท ะ เ บี ย น",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'กลับหน้าเข้าสู่ระบบ  ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return LoginScreen();
                                        }));
                                      },
                                      child: const Text(
                                        'กดตรงนี้ ',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
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
              backgroundColor: Colors.pink.shade50, // สี backgroun
            );
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

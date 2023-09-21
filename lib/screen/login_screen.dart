import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/model/users.dart';
import 'package:tracker_covid_v1/screen/adminscreen/admin_screen.dart';
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
  bool _isLoading = false;

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
                        _buildTitle(),
                        _combinedEmailPasswordResetWidgets(), // Combined widgets
                        _buildLoginButton(),
                        _buildRegisterLink(),
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
      },
    );
  }

  Widget _combinedEmailPasswordResetWidgets() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity, // This gives the maximum width.
        height: 250, // Set height as needed.
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // This centers the widgets inside.
              children: [
                const SizedBox(
                  height: 40,
                ),
                _buildEmailField(),
                const SizedBox(
                  height: 0,
                ),
                _buildPasswordField(),
                const SizedBox(
                  height: 0,
                ),
                _buildResetPasswordLink(),
              ]),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'เข้าสู่ระบบ',
            style: GoogleFonts.prompt(
              fontSize: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _emailController,
        validator: MultiValidator([
          EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
          RequiredValidator(errorText: "กรุณากรอก-อีเมล"),
        ]),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'อีเมล',
          labelStyle: GoogleFonts.prompt(),
          hintText: 'อีเมล',
          hintStyle: GoogleFonts.prompt(),
          prefixIcon: const Icon(Icons.mail),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _passwordController,
        validator: RequiredValidator(errorText: "กรุณากรอก-รหัสผ่าน"),
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'รหัสผ่าน',
          labelStyle: GoogleFonts.prompt(),
          hintText: 'รหัสผ่าน',
          hintStyle: GoogleFonts.prompt(),
          prefixIcon: const Icon(Icons.key),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('ลืมรหัสผ่านใช่ไหม?   ',
              style: GoogleFonts.prompt(color: Colors.grey)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResetPassword()));
            },
            child: Text(
              'รีเซ็ตรหัสผ่าน',
              style: GoogleFonts.prompt(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.20, vertical: 20),
      child: ElevatedButton(
        onPressed: _loginFunction,
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
            : Text(
                "ลงชื่อเข้าใช้",
                style: GoogleFonts.prompt(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ยังไม่มีบัญชีใช่ไหม?   ',
              style: GoogleFonts.prompt(color: Colors.grey)),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()));
            },
            child: Text(
              'ลงทะเบียน',
              style: GoogleFonts.prompt(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This function will handle user login.
  Future<void> _loginFunction() async {
    if (fromKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading spinner while processing login
      });

      fromKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          Users? u = await Users.getUser(uid);
          if (u != null && (u.role == 3 || u.role == null)) {
            // If user is not an admin, navigate to the main page
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    user: userCredential.user,
                  ),
                ),
              );
            }
          } else {
            // If user is an admin, navigate to the admin page
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DoctorScreen(
                    user: u!,
                  ),
                ),
              );
            }
          }
        }
      } on FirebaseAuthException catch (e) {
        // Instead of Fluttertoast, let's use a SnackBar
        final snackBar = SnackBar(content: Text(e.message!));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() {
          _isLoading = false; // Stop the loading spinner after processing
        });
      }
    }
  }
}

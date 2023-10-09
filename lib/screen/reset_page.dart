import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/login_screen.dart';
import 'package:lottie/lottie.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      // ignore: use_build_context_synchronously
      _showCustomDialog(
        context,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'ส่งเรียบร้อย',
            style: GoogleFonts.prompt(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'ระบบได้ทำการส่ง ลิ้งไปยัง อีเมลของคุณเพื่อเปลี่ยนรหัสผ่าน โปรดเช็คอีเมลของคุณ ',
            style: GoogleFonts.prompt(fontSize: 18.0),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ตกลง',
                style: GoogleFonts.prompt(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
            ),
          ],
        ),
      );
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
      // ignore: use_build_context_synchronously
      _showCustomDialog(
        context,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5.0,
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[300],
                size: 24.0,
              ),
              SizedBox(width: 10.0),
              Text(
                'แจ้งเตือน',
                style: GoogleFonts.prompt(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'กรุณากรอก',
                  style: GoogleFonts.prompt(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: ' อีเมล',
                  style: GoogleFonts.prompt(
                    fontSize: 18.0,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ตกลง',
                style: GoogleFonts.prompt(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showCustomDialog(BuildContext context, Widget child) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (context, animation1, animation2) {
        return child;
      },
      transitionBuilder: (context, animation1, animation2, widget) {
        return FadeTransition(
          opacity: animation1,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation1,
              curve: Curves.elasticInOut,
              reverseCurve: Curves.elasticOut,
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Add this line
              crossAxisAlignment: CrossAxisAlignment.center, // Add this line
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon:
                        Icon(Icons.arrow_back_ios_new, color: Colors.red[300]),
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                  ),
                ),
                Lottie.asset('assets/animations/reset_password.json',
                    width: 300, height: 300),
                const SizedBox(height: 10),
                Text(
                  'ลืมรหัสผ่าน',
                  style: GoogleFonts.prompt(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[300]),
                ),
                const SizedBox(height: 8),
                Text(
                  'ใส่อีเมลของคุณ เพื่อ ทำการเปลี่ยนรหัสผ่าน',
                  style: GoogleFonts.prompt(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.prompt(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors
                        .white, // This line sets the background color of the box
                    filled: true, // This line makes the fillColor effective
                    prefixIcon: Icon(Icons.email, color: Colors.red[300]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.red.shade300, width: 1.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'กรอกอีเมลตรงนี้',
                    hintStyle: GoogleFonts.prompt(color: Colors.grey.shade400),
                    labelText: 'Email',
                    labelStyle: GoogleFonts.prompt(
                        color: Colors.grey.shade700, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: passwordReset,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 49),
                    primary: Colors.red[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: GoogleFonts.prompt(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('เปลี่ยนรหัสผ่าน'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

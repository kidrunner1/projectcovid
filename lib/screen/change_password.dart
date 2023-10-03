import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tracker_covid_v1/screen/main_page.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final _auth = FirebaseAuth.instance;

  Future<void> changePassword() async {
    if (_newPasswordController.text == _confirmPasswordController.text) {
      try {
        // Get the current user
        User? user = _auth.currentUser;

        // Reauthenticate the user to confirm their identity
        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _currentPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);

        // If reauthentication is successful, change password
        await user.updatePassword(_newPasswordController.text);

        // Show a success dialog and then navigate back
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text('แก้ไขรหัสผ่านเรียบร้อย.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              )
            ],
          ),
        );
      } catch (e) {
        // Handle the error
        print(e);
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              'กรุณาหรอกรหัสผ่านเพื่อทำการเปลี่ยน.',
              style: GoogleFonts.prompt(),
            ),
            actions: [
              TextButton(
                child: Text(
                  'ตกลง',
                  style: GoogleFonts.prompt(),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget buildPasswordField(String label, TextEditingController controller,
      bool obscureText, VoidCallback toggleVisibility) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple.shade200),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.prompt(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: 'ใส่$label',
                hintStyle: GoogleFonts.prompt(),
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: toggleVisibility,
                  child: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แก้ไขรหัสผ่าน',
          style: GoogleFonts.prompt(),
        ),
        backgroundColor: Colors.red[300],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              buildPasswordField('รหัสผ่านปัจจุบัน', _currentPasswordController,
                  _obscureCurrentPassword, () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              }),
              const SizedBox(height: 20),
              buildPasswordField(
                  'รหัสผ่านใหม่', _newPasswordController, _obscureNewPassword,
                  () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              }),
              const SizedBox(height: 20),
              buildPasswordField('ยืนยันรหัสผ่าน', _confirmPasswordController,
                  _obscureConfirmPassword, () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              }),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                  minimumSize: Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('เปลี่ยนรหัสผ่าน',
                    style: GoogleFonts.prompt(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

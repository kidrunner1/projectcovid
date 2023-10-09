import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
            User? user = _auth.currentUser;

            AuthCredential credential = EmailAuthProvider.credential(
                email: user!.email!,
                password: _currentPasswordController.text,
            );

            await user.reauthenticateWithCredential(credential);
            await user.updatePassword(_newPasswordController.text);

            // ignore: use_build_context_synchronously
            Alert(
                context: context,
                type: AlertType.success,
                title: "สำเร็จ",
                desc: "แก้ไขรหัสผ่านเรียบร้อย.",
                style: AlertStyle(
                    titleStyle: GoogleFonts.prompt(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                    ),
                    descStyle: GoogleFonts.prompt(color: Colors.black),
                ),
                buttons: [
                    DialogButton(
                        // ignore: sort_child_properties_last
                        child: Text(
                            "ตกลง",
                            style: GoogleFonts.prompt(color: Colors.white),
                        ),
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage())),
                        color: Colors.green,
                    )
                ],
            ).show();

        } catch (e) {
            print(e);

            // ignore: use_build_context_synchronously
            Alert(
                context: context,
                type: AlertType.error,
                title: "แจ้งเตือน",
                desc: "กรุณาหรอกรหัสผ่านเพื่อทำการเปลี่ยน.",
                style: AlertStyle(
                    titleStyle: GoogleFonts.prompt(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                    ),
                    descStyle: GoogleFonts.prompt(color: Colors.white),
                ),
                buttons: [
                    DialogButton(
                        // ignore: sort_child_properties_last
                        child: Text(
                            "ตกลง",
                            style: GoogleFonts.prompt(color: Colors.white),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        color: Colors.red[300],
                    )
                ],
            ).show();
        }
    }
}


  Widget _buildErrorDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 300,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/error.json",
                width: 100, height: 100),
            Text(
              'กรุณาหรอกรหัสผ่านเพื่อทำการเปลี่ยน.',
              style: GoogleFonts.prompt(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              child: Text(
                'ตกลง',
                style: GoogleFonts.prompt(
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
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
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Hero(
        tag: label,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueGrey.shade300),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 15,
                offset: const Offset(0, 6),
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
                  color: Colors.black87,
                ),
              ),
              TextField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: 'ใส่$label',
                  hintStyle: GoogleFonts.prompt(
                    color: Colors.blueGrey.shade200,
                  ),
                  border: InputBorder.none,
                  suffixIcon: GestureDetector(
                    onTap: toggleVisibility,
                    child: Icon(
                        obscureText
                            ? Icons.lock_outline
                            : Icons.lock_open_outlined,
                        color: Colors.blueGrey.shade400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red[50]!,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.red[300]),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 200,
                  child: Lottie.asset('assets/animations/animation_icon.json'),
                ),
                Text(
                  'แก้ไขรหัสผ่าน',
                  style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.red[300],
                  ),
                ),
                const SizedBox(height: 40),
                buildPasswordField('รหัสผ่านปัจจุบัน',
                    _currentPasswordController, _obscureCurrentPassword, () {
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
                const SizedBox(height: 40),
                Transform.scale(
                  scale: 1.2,
                  child: ElevatedButton(
                    onPressed: changePassword,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red[300],
                      primary: Colors.red[300],
                      minimumSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Colors.red[300]!),
                      ),
                      shadowColor: Colors.teal[700],
                    ),
                    child: Text('เปลี่ยนรหัสผ่าน',
                        style: GoogleFonts.prompt(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

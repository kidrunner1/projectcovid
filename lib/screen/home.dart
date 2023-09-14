import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/login_screen.dart';
import 'package:tracker_covid_v1/screen/register.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // <- Wrap the content with the Center widget
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the items vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center the items horizontally
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/logo.png",width: 180,),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'แอปพลิเคชันติดตามและ \n ประเมินผู้ที่มีความเสี่ยงโควิด-19',
              style: GoogleFonts.prompt(
                fontSize: 22,
                fontWeight: FontWeight.bold,color: Colors.red[300]
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Register ID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.red.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 5,
                      textStyle: GoogleFonts.prompt(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    child: const SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text("สร้างบัญชีผู้ใช้"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Login Page
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      primary: Colors.red.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 5,
                      textStyle: GoogleFonts.prompt(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text("เข้าสู่ระบบ"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      backgroundColor: Colors.pink[50],
    );
  }
}

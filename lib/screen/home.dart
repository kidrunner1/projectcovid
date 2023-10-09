import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tracker_covid_v1/screen/login_screen.dart';
import 'package:tracker_covid_v1/screen/register.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[50]!, Colors.red[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimationLimiter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 600),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 180,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'แอปพลิเคชันติดตามและ \n ประเมินผู้ที่มีความเสี่ยงโควิด-19',
                    style: GoogleFonts.prompt(
                        fontSize: 22,
                        shadows: [],
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _customButton(
                          context,
                          "เข้าสู่ระบบ",
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _customButton(
                          context,
                          "สร้างบัญชีผู้ใช้",
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customButton(BuildContext context, String title, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.red[300],
        padding: EdgeInsets.symmetric(vertical: 12),
        elevation: 5,
        shadowColor: Colors.black45,
        textStyle: GoogleFonts.prompt(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.prompt(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/change_password.dart';
import 'package:tracker_covid_v1/screen/profile_setting.dart';
import 'package:tracker_covid_v1/screen/version_app.dart';

class SettingDrawer extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingDrawer> {
  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pink[50], // This should be inside Scaffold
        body: Column(
          children: [
            // Back button on the top left
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.red[300]),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // Your main content
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink[100]!, Colors.red[50]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink[200]!.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Shrink wrapping the column
                      children: [
                        Text(
                          "การตั้งค่า",
                          style: GoogleFonts.prompt(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 30),
                        _buildSettingButton(
                            "ข้อมูลส่วนตัว", Icons.person, ProfileSetting()),
                        const SizedBox(height: 20),
                        _buildSettingButton("ตั้งค่ารหัสผ่าน", Icons.lock,
                            ChangePasswordScreen()),
                        const SizedBox(height: 20),
                        _buildSettingButton(
                            "เกี่ยวกับ", Icons.info, VerSionSceen()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingButton(String title, IconData iconData, Widget page) {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          _navigateToPage(page);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shadowColor: Colors.pink[200],
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Aligns the items to the left
          children: [
            Icon(iconData, color: Colors.red[300]), // Your initial icon
            const SizedBox(width: 10), // A little spacing
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.prompt(
                  color: Colors.red[300],
                  fontSize: 20,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.red[300],
            ) // This is the arrow icon at the end
          ],
        ),
      ),
    );
  }
}

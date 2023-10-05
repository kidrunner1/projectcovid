import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/model/users.dart';
import 'package:tracker_covid_v1/screen/adminscreen/drawer_admin.dart';
import 'package:tracker_covid_v1/screen/adminscreen/main_page_admin..dart';
import 'package:tracker_covid_v1/screen/profile_page.dart';
import 'admin_manager.dart';

class DoctorScreen extends StatefulWidget {
  final Users user;
  DoctorScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  late Users user;
  int roleID = 3;
  int _currentIndex = 0; // For BottomNavigationBar

  @override
  void initState() {
    super.initState();
    user = widget.user;
    roleID = user.role ?? 3;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget getScreen(int index) {
    switch (index) {
      case 0:
        return MainPageAdmin();
      case 1:
        return SettingsScreen();
      case 2:
        return ProfileBox();
      default:
        return MainPageAdmin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "หมอพยาบาล",
          style: GoogleFonts.prompt(),
        ),
        actions: roleID == 1
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminManagerScreen(),
                      ),
                    );
                  },
                  icon: const Icon(FontAwesomeIcons.userCog),
                ),
              ]
            : null,
        backgroundColor: Colors.red[300],
      ),
      drawer: NavigationAdmin(),
      body: getScreen(_currentIndex), // Call the function here
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.gear),
            label: 'ตั่่งค่า',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.person),
            label: 'ข้อมูลส่วนตัว',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.red[400],
        selectedItemColor: Colors.grey[300],
        unselectedItemColor: Colors.white70,
        unselectedLabelStyle: GoogleFonts.prompt(
          color: Colors.white.withOpacity(0.7),
          fontSize: 12,
        ),
        selectedLabelStyle: GoogleFonts.prompt(
          color: Colors.deepPurple.shade50,
          fontSize: 14,
        ),
      ),
    );
  }
}

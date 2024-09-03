import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/notification.dart';

import 'package:tracker_covid_v1/screen/profile_page.dart';
import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/widget/drawer.dart';

import '../feture/chat.dart';
import '../feture/news_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  ValueNotifier<int> notificationCount = ValueNotifier<int>(1);

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [
    const NewsScreens(),
    ChatScreen(),
    SettingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 15,
          shadowColor: Colors.black38,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: IndexedStack(
              index: _currentIndex,
              children: _children,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'แชท',
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
        backgroundColor: Colors.red[300],
        selectedItemColor: Colors.white,
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
      appBar: AppBar(
        elevation: 15,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Colors.red[300],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: notificationCount,
            builder: (context, count, child) {
              return Stack(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()),
                        );
                        notificationCount.value =
                            0; // Resetting notification count after viewing
                      },
                      icon:
                          const Icon(Icons.notifications, color: Colors.white)),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          count.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: const NavigatorScreen(),
    );
  }
}

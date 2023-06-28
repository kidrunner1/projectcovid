import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tracker_covid_v1/feture/data.dart';

import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/screen/home.dart';
import 'package:tracker_covid_v1/screen/map.dart';
import 'package:tracker_covid_v1/screen/welcome.dart';

import '../feture/call.dart';
import '../feture/chat.dart';
import '../feture/news_screen.dart';
import '../feture/data.dart';
import '../widget/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [
    const NewsScreens(),
    const ChatScreen(),
    const SettingScreen(),
    const PersonScreen()
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink.shade100,
        selectedItemColor: Colors.pink.shade200,
        unselectedItemColor: Colors.pink,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'แชท',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'ตั่่งค่า',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ข้อมูลส่วนตัว',
          )
        ],
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CallBackScreens()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      drawer: const NavigationDrawer(),
    );
  }
}

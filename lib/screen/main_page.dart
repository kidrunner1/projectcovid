import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tracker_covid_v1/screen/profile_page.dart';

import 'package:tracker_covid_v1/feture/setting.dart';

import '../feture/chat.dart';
import '../feture/news_screen.dart';
import '../widget/drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.user});
  final String title;
  final User? user;

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
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red.shade300,
        selectedItemColor: Colors.red.shade300,
        unselectedItemColor: Colors.red.shade300,
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
        backgroundColor: Colors.red.shade300,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingScreen()));
              },
              icon: const Icon(Icons.notifications))
        ],
      ),
      // ignore: prefer_const_constructors
      drawer: const NavigationDrawer(),
    );
  }
}

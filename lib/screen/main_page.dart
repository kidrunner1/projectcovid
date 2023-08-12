import 'package:flutter/material.dart';

import 'package:tracker_covid_v1/feture/profile_page.dart';

import 'package:tracker_covid_v1/feture/setting.dart';

import '../feture/chat.dart';
import '../feture/news_screen.dart';
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
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink.shade200,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.pink.shade200,
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
        backgroundColor: Colors.pink.shade200,
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/screen/home.dart';
import 'package:tracker_covid_v1/screen/map.dart';
import 'package:tracker_covid_v1/screen/welcome.dart';

import '../feture/call.dart';
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
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown, selectedItemColor: Colors.grey.shade800,
        unselectedItemColor: Colors.white,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            label: 'ข่าวสาร',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'แชท',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'ตั่่งค่า',
          ),
        ],
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CallBackScreens()));
              },
              icon: const Icon(Icons.add_call))
        ],
      ),
      drawer: const NavigationDrawer(),
    );
  }
}

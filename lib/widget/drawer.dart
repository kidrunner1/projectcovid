import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/profile_page.dart';
import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/screen/login_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAuth_auth = FirebaseAuth.instance;

class NavigatorScreen extends StatelessWidget {
  const NavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          builderHeader(context),
          buildMenuItems(context),
        ],
      )),
    );
  }
}

Widget builderHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(
        top: 24 + MediaQuery.of(context).padding.top,
        bottom: 24,
      ),
      child: const Column(children: [
        DrawerHeader(
            child: Icon(
          Icons.person,
          color: Colors.black,
          size: 60,
        ))
      ]),
    );

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: const Text(
              'ข้อมูลส่วนตัว',
              style: TextStyle(color: Colors.black),
            ),
            onTap: (() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ));
            }),
          ),
          ListTile(
            leading: const Icon(
              Icons.home_filled,
              color: Colors.black,
            ),
            title: const Text(
              'การตั้งค่า',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: const Text(
              'ออกจากระบบ',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () async {
              await _auth.signOut().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) {
                  return LoginScreen();
                })));
              });
            },
          ),
        ],
      ),
    );

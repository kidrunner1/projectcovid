import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/profile_page.dart';
import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/screen/login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAuth_auth = FirebaseAuth.instance;

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

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
              'ข้ อ มู ล ส่ ว น ตั ว',
              style: TextStyle(color: Colors.black),
            ),
            onTap: (() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserProfileScreen(),
              ));
            }),
          ),
          ListTile(
            leading: const Icon(
              Icons.home_filled,
              color: Colors.black,
            ),
            title: const Text(
              'ก า ร ตั้ ง ค่ า',
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
              'อ อ ก จ า ก ร ะ บ บ',
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

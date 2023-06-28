import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/feture/data.dart';
import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/screen/login.dart';
import 'package:tracker_covid_v1/screen/map.dart';
import 'package:tracker_covid_v1/screen/welcome.dart';

import '../screen/home.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAuth_auth = FirebaseAuth.instance;

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
      color: Colors.brown.shade700,
      padding: EdgeInsets.only(
        top: 24 + MediaQuery.of(context).padding.top,
        bottom: 24,
      ),
      child: Column(
        children: const [
          CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/5905356/pexels-photo-5905356.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
          ),
          SizedBox(height: 12),
          Text('Name', style: TextStyle(fontSize: 28, color: Colors.white)),
          Text('Lastname', style: TextStyle(fontSize: 28, color: Colors.white))
        ],
      ),
    );

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('ข้อมูลส่วนตัว'),
            onTap: (() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PersonScreen(),
              ));
            }),
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('การตั้งค่า'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('ออกจากระบบ'),
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

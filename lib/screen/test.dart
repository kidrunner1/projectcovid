import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/login.dart';
import 'package:tracker_covid_v1/screen/map.dart';
import 'package:tracker_covid_v1/screen/welcome.dart';

import 'home.dart';

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
      color: Colors.amber.shade700,
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
          Text('GG', style: TextStyle(fontSize: 28, color: Colors.white)),
          Text('GG', style: TextStyle(fontSize: 28, color: Colors.white))
        ],
      ),
    );

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: ((context) => const HomeScreen())));
            },
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('แผนที่'),
            onTap: (() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MapSample(),
              ));
            }),
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('หน้าหลัก'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ));
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.account_tree_outlined),
            title: const Text('Plugins'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Updates'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
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

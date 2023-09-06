import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/profile_edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: ListView(children: [
        const SizedBox(height: 50),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ข้ อ มู ล ส่ ว น ตั ว',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        // profile pic
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.person,
            size: 80,
          ),
        ),

        // user email
        Text(
          currentUser!.email!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black),
        ),

        // user detail

        // username
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const EditProfilePage();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.green.shade300,
                shape: StadiumBorder(),
              ),
              child: const Text('แ ก้ ไข ข้ อ มู ล '),
            ),
          ],
        )
      ]),
    );
  }
}

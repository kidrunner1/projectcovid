import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracker_covid_v1/screen/main_page.dart';
import 'package:tracker_covid_v1/screen/profile_edit_page.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50, // Light pink background
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser?.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.active) {
              Map<String, dynamic>? data =
                  snapshot.data?.data() as Map<String, dynamic>?;
              return ProfileBox(data: data);
            }

            return const CircularProgressIndicator(); // Loading indicator while fetching data
          },
        ),
      ),
    );
  }
}

class ProfileBox extends StatelessWidget {
  final Map<String, dynamic>? data;

  ProfileBox({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      // Removed the height constraint to let the content determine its own height
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        // Added SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                size: 90,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              "${data?['firstName']} ${data?['lastName']}",
              style: const TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditProfileScreen()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5.0,
                  shadowColor: Colors.black),
              child: const Text(
                'แก้ไขข้อมูล',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

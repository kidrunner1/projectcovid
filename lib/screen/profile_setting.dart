import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/profile_edit_page.dart';

class ProfileSetting extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Lighter background
      body: Stack(
        children: [
          // The back arrow button
          Positioned(
            top: 40, // Adjust this value as needed for positioning
            left: 10, // Adjust this value as needed for positioning
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // The rest of your profile content
          Center(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_auth.currentUser?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  Map<String, dynamic>? data =
                      snapshot.data?.data() as Map<String, dynamic>?;
                  return ProfileBox(data: data);
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileBox extends StatelessWidget {
  final Map<String, dynamic>? data;

  ProfileBox({this.data});

  @override
  Widget build(BuildContext context) {
    String? photoURL = data?['photoURL'];
    return Card(
      elevation: 5, // Shadow effect
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  (photoURL != null) ? NetworkImage(photoURL) : null,
              child: (photoURL == null)
                  ? Icon(Icons.person, size: 70, color: Colors.grey[400])
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              "${data?['firstName']} ${data?['lastName']}",
              style:
                  GoogleFonts.prompt(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              "${data?['email'] ?? 'ไม่มีข้อมูล'}", // Display email or default text if not available
              style: GoogleFonts.prompt(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              "${data?['phoneNumber'] ?? 'ไม่มีข้อมูล'}", // Display phone number or default text if not available
              style: GoogleFonts.prompt(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditProfileScreen()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor:
                    Colors.red[300], // Consistent color with AppBar
              ),
              child: Text(
                'แก้ไขข้อมูล',
                style: GoogleFonts.prompt(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

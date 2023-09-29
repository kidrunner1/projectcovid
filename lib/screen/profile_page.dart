import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/profile_edit_page.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Lighter background

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

            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.red[300]!), // Consistent color
            );
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
    String? photoURL = data?['photoURL'];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 8, // Increased Shadow effect
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)), // More rounded
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 70, // Increased size
                backgroundImage:
                    (photoURL != null) ? NetworkImage(photoURL) : null,
                child: (photoURL == null)
                    ? Icon(Icons.person,
                        size: 80,
                        color: Colors.grey[400]) // Increased icon size
                    : null,
              ),
              const SizedBox(height: 25),
              Text(
                "${data?['firstName']} ${data?['lastName']}",
                style: GoogleFonts.prompt(
                    fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, size: 20, color: Colors.grey[600]),
                  SizedBox(width: 5),
                  Text(
                    "${data?['email'] ?? 'ไม่มีข้อมูล'}",
                    style: GoogleFonts.prompt(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, size: 20, color: Colors.grey[600]),
                  SizedBox(width: 5),
                  Text(
                    "${data?['phoneNumber'] ?? 'ไม่มีข้อมูล'}",
                    style: GoogleFonts.prompt(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfileScreen()));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15), // More padding
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)), // More rounded
                  backgroundColor: Colors.red[300],
                ),
                child: Text(
                  'แก้ไขข้อมูล',
                  style: GoogleFonts.prompt(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18), // Increased font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

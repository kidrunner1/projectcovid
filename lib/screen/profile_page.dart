import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracker_covid_v1/widget/profile_box.dart';

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

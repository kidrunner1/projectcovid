import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('users');
  User? user;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    _fetchUserData();
  }

  _fetchUserData() async {
    if (user != null) {
      print("Fetching data for user: ${user!.uid}");
      try {
        DocumentSnapshot document = await firestore.doc(user!.uid).get();
        if (document.exists) {
          print("User data found: ${document.data()}");
          setState(() {
            userData = document.data() as Map<String, dynamic>;
          });
        } else {
          print("No user data found for user: ${user!.uid}");
        }
      } catch (error) {
        print("Error fetching user data: $error");
      }
    } else {
      print("No user is logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100), // Person Icon
            const SizedBox(height: 20),
            if (userData == null) ...[
              // If userData is null, show this message
              Text(
                'No user data available',
                style: const TextStyle(fontSize: 24, color: Colors.red),
              ),
              const SizedBox(height: 20),
            ] else ...[
              // If userData is not null, show user details
              Text(
                '${userData!['first name']} ${userData!['last name']}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: TextEditingController(text: userData!['email']),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller:
                    TextEditingController(text: userData!['phone number']),
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

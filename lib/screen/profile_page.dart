import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {

  final User? user;

  const ProfileScreen({super.key, this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}





class _ProfileScreenState extends State<ProfileScreen> {
  late Future<DocumentSnapshot> userData;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  

  User? user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  Future<DocumentSnapshot> getUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
    }
    throw Exception('User not logged in');
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot
                .error); // This line will print the error to your console.
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.exists) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ชื่อ: ${snapshot.data!.get('name')}'),
                  Text('นามสกุล: ${snapshot.data!.get('last name')}'),
                  Text('อีเมล: ${snapshot.data!.get('email')}'),
                  Text('เบอร์โทร: ${snapshot.data!.get('phone number')}'),
                  // ... Add more fields as required.
                ],
              ),
            );
          }
          return const Center(child: Text('ไม่พบข้อมูลผู้ใช้'));
        },
      ),
    );
  }
}

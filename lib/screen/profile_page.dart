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

  String? userEmail;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    
  }

 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
    );
  }
}

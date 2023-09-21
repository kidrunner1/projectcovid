import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tracker_covid_v1/model/users.dart';
import 'admin_manager.dart';

class DoctorScreen extends StatefulWidget {
  final Users user;
  DoctorScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  late Users user;
  int roleID = 3;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    roleID = user.role ?? 3;
  }

  Future<void> _updateUserRole(String uid, int role) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'role': role,
    });
  }

  Future<void> _deleteUser(Users user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    // Note: You should also handle deleting the user from Firebase Auth if necessary.
  }

  Stream<List<Users>> _getUsersStream() {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Users.fromDocument(doc),
              )
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("หมอพยาบาล"),
          actions: roleID == 1
              ? [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminManagerScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings))
                ]
              : null,
          backgroundColor: Colors.red[300],
        ),
        body: Container());
  }
}

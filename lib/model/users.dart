import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users {
  String? email;
  String? firstName;
  String? lastName;
  bool? isAdmin;

  String? phoneNumber;
  String? photoURL;

  Users({
    this.email,
    this.firstName,
    this.lastName,
    this.isAdmin,
    this.phoneNumber,
    this.photoURL,
  });

  static Future<Users?> getUser(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    try {
      Map<String, dynamic>? u = snapshot.data() as Map<String, dynamic>?;
      if (u != null) {
        Users user = Users(
          email: u['email'],
          firstName: u['firstName'],
          lastName: u['lastName'],
          isAdmin: u['isAdmin'],
          phoneNumber: u['phoneNumber'],
          photoURL: u['photoURL'],
        );
        return user;
      }
      return null;
    } catch (err) {
      return null;
    }
  }
}

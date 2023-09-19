// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String uid;
  String? email;
  String? firstName;
  String? lastName;
  int? role;
  // bool? isAdmin;
  String? phoneNumber;
  String? photoURL;

  Users({
    required this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    // this.isAdmin,
    this.phoneNumber,
    this.photoURL,
  });

  static Future<Users?> getUser(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        Map<String, dynamic>? u = snapshot.data() as Map<String, dynamic>?;

        if (u != null) {
          Users user = Users(
            uid: snapshot.id,
            email: u['email'] as String?,
            firstName: u['firstName'] as String?,
            lastName: u['lastName'] as String?,
            // isAdmin: u['isAdmin'] as bool?,
            role: u['role'],
            phoneNumber: u['phoneNumber'] as String?,
            photoURL: u['photoURL'] as String?,
          );
          return user;
        }
      }
      return null;
    } catch (err) {
      print(
          "Error getting user data: $err"); // This will print the error in your debug console.
      return null;
    }
  }

  static Future<List<Users>?> getUsers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("users").get();

      List<Users> users = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        Users u = Users(
          uid: doc.id,
          email: data['email'],
          firstName: data['firstName'],
          lastName: data['lastName'],
          // isAdmin: u['isAdmin'] as bool?,
          role: data['role'],
          phoneNumber: data['phoneNumber'],
          photoURL: data['photoURL'],
        );
        return u;
      }).toList();
      if (users.isNotEmpty) {
        return users;
      }
      return null;
    } catch (err) {
      print(
          "Error getting user data: $err"); // This will print the error in your debug console.
      return null;
    }
  }

  static updateRoleUser(String uid, int i) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'role': 1,
    });
  }

  // Add this factory constructor inside your Users class
  factory Users.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Users(
      uid: doc.id,
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      role: data['role'],
      phoneNumber: data['phoneNumber'],
      photoURL: data['photoURL'],
    );
  }

// Add this static method inside your Users class to fetch the stream
  static Stream<List<Users>> getUsersStream() {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Users.fromDocument(doc),
              )
              .toList(),
        );
  }

  static fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
}

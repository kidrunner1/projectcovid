import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id; // Add ID
  final String? firstName;
  final String? lastName;

  User({this.id, this.firstName, this.lastName});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id, // Fetch ID
      firstName: doc['firstName'],
      lastName: doc['lastName'],
    );
  }
}

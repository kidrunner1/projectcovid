import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/model/users.dart';

class AdminManagerScreen extends StatefulWidget {
  AdminManagerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminManagerScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminManagerScreen> {
  late Users user;

  @override
  void initState() {
    super.initState();
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
        title: Text(
          "ผู้ดูแลระบบ",
          style: GoogleFonts.prompt(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.red[300],
      ),
      body: StreamBuilder<List<Users>>(
        stream: _getUsersStream(),
        builder: (context, AsyncSnapshot<List<Users>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<Users> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              Users u = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  title: Text(u.email ?? "No Email",
                      style: GoogleFonts.poppins(fontSize: 16.0)),
                  subtitle: Text(
                    "${u.firstName} ${u.lastName} - ${roleToString(u.role ?? 3)}",
                    style: GoogleFonts.poppins(
                        fontSize: 14.0, color: Colors.grey[600]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(roleToString(u.role ?? 3),
                            style: GoogleFonts.poppins(fontSize: 12.0)),
                        backgroundColor:
                            roleToColor(u.role ?? 3).withOpacity(0.2),
                        side: BorderSide(color: roleToColor(u.role ?? 3)),
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.delete_outline, color: Colors.red[400]),
                        onPressed: () {
                          // show a confirmation dialog before deletion
                          _showDeletionDialog(u);
                        },
                      ),
                    ],
                  ),
                  onTap: () => _showRoleDialog(u),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.red[50],
    );
  }

  // Updated Dialogs with a modern look
  void _showRoleDialog(Users user) {
    int? selectedRole = user.role; // initial value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              title: Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.grey[600]),
                  SizedBox(width: 10),
                  Text(
                    'กำหนดสิทธิ์ผู้ใช้งาน',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: selectedRole,
                    onChanged: (newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                    items:
                        <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          roleToString(value),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _updateUserRole(user.uid!, selectedRole!);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeletionDialog(Users user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red[400]),
              SizedBox(width: 10),
              Text(
                'Confirm Deletion',
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
          content: Text(
              'Do you want to delete ${user.email}? This action cannot be undone.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _deleteUser(user);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Utility functions:
Color roleToColor(int role) {
  switch (role) {
    case 1:
      return Colors.blue;
    case 2:
      return Colors.green;
    default:
      return Colors.grey;
  }
}

String roleToString(int role) {
  switch (role) {
    case 1:
      return "Admin";
    case 2:
      return "User";
    default:
      return "Guest";
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/model/users.dart';
import 'admin_manager.dart';

class AdminScreen extends StatefulWidget {
  final Users user;
  AdminScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
        title: const Text("ผู้ดูแลระบบ"),
        actions: roleID == 1
            ? [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminManagerScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings))
              ]
            : null,
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  title: Text(u.email ?? "No Email",
                      style: GoogleFonts.prompt(fontSize: 16.0)),
                  subtitle: Text(
                    "${u.firstName} ${u.lastName} - ${roleToString(u.role ?? 3)}",
                    style: GoogleFonts.prompt(
                        fontSize: 14.0, color: Colors.grey[600]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(u),
                      ),
                      Chip(
                        label: Text(roleToString(u.role ?? 3),
                            style: GoogleFonts.prompt(fontSize: 12.0)),
                        backgroundColor: roleToColor(u.role ?? 3),
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
    );
  }

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
              title: const Text(
                'กำหนดสิทธิ์ผู้ใช้งาน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
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
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.grey.shade800,
                  ),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10.0),
                  ),
                  child: const Text(
                    'UPDATE',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () async {
                    if (selectedRole != null) {
                      await _updateUserRole(user.uid, selectedRole!);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(Users user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: [
            TextButton(
              child: const Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("DELETE"),
              onPressed: () async {
                await _deleteUser(user);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String roleToString(int role) {
    switch (role) {
      case 1:
        return "Admin";
      case 2:
        return "Doctor/Nurse";
      case 3:
      default:
        return "User";
    }
  }

  Color roleToColor(int role) {
    switch (role) {
      case 1:
        return Colors.red[300]!;
      case 2:
        return Colors.blue;
      case 3:
      default:
        return Colors.grey.shade300;
    }
  }
}

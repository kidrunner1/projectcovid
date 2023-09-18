import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to import this package
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data"),
        actions: roleID == 1
            ? [
                IconButton(
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminManagerScreen(),
                            ),
                          )
                        },
                    icon: const Icon(Icons.settings))
              ]
            : null,
        backgroundColor: Colors.red[300],
      ),
      body: FutureBuilder<List<Users>?>(
        future: Users.getUsers(),
        builder: (context, AsyncSnapshot<List<Users>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const Center(child: Text('Something went wrong'));
            }
            List<Users>? users = snapshot.data;
            return ListView.builder(
              itemCount: users!.length,
              itemBuilder: (context, index) {
                Users u = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(u.email ?? "No Email",
                        style: GoogleFonts.prompt(fontSize: 16.0)),
                    subtitle: Text(
                      "${u.firstName} ${u.lastName} - ${roleToString(u.role ?? 3)}",
                      style: GoogleFonts.prompt(
                          fontSize: 14.0, color: Colors.grey[600]),
                    ),
                    trailing: Chip(
                      label: Text(roleToString(u.role ?? 3),
                          style: GoogleFonts.prompt(fontSize: 12.0)),
                      backgroundColor: roleToColor(u.role ?? 3),
                    ),
                    onTap: () => _showRoleDialog(u),
                  ),
                );
              },
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  void _showRoleDialog(Users user) {
    int? selectedRole = user.role; // initial value
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update User Role'),
          content: DropdownButton<int>(
            value: selectedRole,
            onChanged: (newValue) {
              setState(() {
                selectedRole = newValue;
              });
            },
            items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(roleToString(value)),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('UPDATE'),
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
        return Colors.blue; // Color for Admin
      case 2:
        return Colors.green; // Color for Doctor/Nurse
      case 3:
      default:
        return Colors.grey; // Color for User
    }
  }
}

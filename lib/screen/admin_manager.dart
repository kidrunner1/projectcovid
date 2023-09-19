import 'package:flutter/material.dart';

import '../model/users.dart';

class AdminManagerScreen extends StatefulWidget {
  const AdminManagerScreen({super.key});

  @override
  State<AdminManagerScreen> createState() => _AdminManagerScreenState();
}

class _AdminManagerScreenState extends State<AdminManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Manager"),
      ),
      body: FutureBuilder<List<Users>?>(
        future: Users.getUsers(),
        builder: (context, AsyncSnapshot<List<Users>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const Center(child: Text('Something went wrong'));
            }
            List<Users>? users = snapshot.data;
            return ListView(
              children: users!.map((Users u) {
                return ListTile(
                  title: Text(u.email ?? "No Email"),
                  subtitle: Text("${u.firstName} ${u.lastName}"),
                  onTap: () =>
                      _showOptionsDialog(u), // Added onTap to show more options
                );
              }).toList(),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  void _showOptionsDialog(Users user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options for ${user.firstName} ${user.lastName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Check patient history'),
                onTap: () {
                  // Navigate to patient history page or show the history here
                },
              ),
              ListTile(
                title: const Text('Update medicine appointment schedule'),
                onTap: () {
                  // Navigate to medicine schedule page or provide an interface to update
                },
              ),
              ListTile(
                title: const Text('Update vaccination schedule'),
                onTap: () {
                  // Navigate to vaccination schedule page or provide an interface to update
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

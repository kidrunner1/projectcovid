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
                );
              }).toList(),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

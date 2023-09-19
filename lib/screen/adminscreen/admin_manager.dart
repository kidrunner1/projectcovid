import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/users.dart';

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
        elevation: 0.0,
        title: Text(
          "Admin Manager",
          style: GoogleFonts.prompt(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
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
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      // You can display the user's image here
                      backgroundColor: Colors.blueGrey[300],
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(u.email ?? "No Email"),
                    subtitle: Text("${u.firstName} ${u.lastName}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showOptionsDialog(u),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
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
                leading: const Icon(Icons.history, color: Colors.blueGrey),
                title: const Text('Check patient history'),
                onTap: () {
                  // Navigate to patient history page or show the history here
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.calendar_today, color: Colors.blueGrey),
                title: const Text('Update medicine appointment schedule'),
                onTap: () {
                  // Navigate to medicine schedule page or provide an interface to update
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.medical_services, color: Colors.blueGrey),
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

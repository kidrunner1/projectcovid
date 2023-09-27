import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/dailys_details_admin.dart';

class User {
  final String? id; // ID field
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

class GetdataDailysAdminScreen extends StatefulWidget {
  const GetdataDailysAdminScreen({Key? key}) : super(key: key); // Adjusted

  @override
  State<GetdataDailysAdminScreen> createState() =>
      _GetdataDailysAdminScreenState();
}

class _GetdataDailysAdminScreenState extends State<GetdataDailysAdminScreen> {
  late Stream<List<User>> usersStream;

  @override
  void initState() {
    super.initState();
    usersStream = _getUsersStream();
  }

  Stream<List<User>> _getUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 3)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => User.fromDocument(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(
          "รายละเอียดผู้ป่วยประจำวัน",
          style: GoogleFonts.prompt(),
        ),
        elevation: 0.0, // Remove shadow
      ),
      body: StreamBuilder<List<User>>(
        stream: usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No users found.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple[100],
                    child: Text(
                      '${user.firstName!.substring(0, 1)}${user.lastName!.substring(0, 1)}',
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                  title: Text(
                    '${user.firstName} ${user.lastName}',
                    style: GoogleFonts.prompt(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.deepPurple),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyDetailsAdminScreen(
                          userId: user.id!,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

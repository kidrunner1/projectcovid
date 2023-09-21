import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        title: Text("รายละเอียดผู้ป่วยประจำวัน"),
      ),
      body: StreamBuilder<List<User>>(
        stream: usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No users found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
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
              );
            },
          );
        },
      ),
    );
  }
}

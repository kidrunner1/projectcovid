import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/details_envaluate_admin.dart';

class User {
  final String? id; // ID field
  final String? firstName;
  final String? lastName;

  User({this.id, this.firstName, this.lastName});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      firstName: doc['firstName'],
      lastName: doc['lastName'],
    );
  }
}

class DetailsEnvaluateAdminScreen extends StatefulWidget {
  const DetailsEnvaluateAdminScreen({Key? key}) : super(key: key);

  @override
  State<DetailsEnvaluateAdminScreen> createState() =>
      _DetailsEnvaluateAdminScreenState();
}

class _DetailsEnvaluateAdminScreenState
    extends State<DetailsEnvaluateAdminScreen> {
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
        title: Text(
          "รายละเอียดประเมินอาการผู้ป่วยประจำวัน",
          style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[300],
      ),
      body: StreamBuilder<List<User>>(
        stream: usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.prompt(fontSize: 16, color: Colors.redAccent),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              'No users found.',
              style: GoogleFonts.prompt(fontSize: 16),
            ));
          } else {
            List<User> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GetDataenvaluateScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.deepPurple[100],
                              child: Text(
                                '${users[index].firstName![0]}${users[index].lastName![0]}',
                                style: GoogleFonts.prompt(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              '${users[index].firstName} ${users[index].lastName}',
                              style: GoogleFonts.prompt(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.red[50],
    );
  }
}


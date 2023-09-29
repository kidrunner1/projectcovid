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
      id: doc.id,
      firstName: doc['firstName'],
      lastName: doc['lastName'],
    );
  }
}

class GetdataDailysAdminScreen extends StatefulWidget {
  const GetdataDailysAdminScreen({Key? key}) : super(key: key);

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
        .asyncMap((snapshot) async {
      var usersWithResults = <User>[];
      for (var doc in snapshot.docs) {
        var user = User.fromDocument(doc);
        var hasResults = await _userHasDailyResults(user.id!);
        if (hasResults) {
          usersWithResults.add(user);
        }
      }
      return usersWithResults;
    });
  }

  Future<bool> _userHasDailyResults(String userId) async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(microseconds: 1));

    // Convert DateTime to Timestamp
    Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

    var resultsSnapshot = await FirebaseFirestore.instance
        .collection('checkResults')
        .where('userID', isEqualTo: userId)
        .where('timestamp',
            isGreaterThanOrEqualTo:
                startTimestamp) // Replace 'timestampFieldName' with the actual field name
        .where('timestamp',
            isLessThanOrEqualTo:
                endTimestamp) // Replace 'timestampFieldName' with the actual field name
        .get();

    return resultsSnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายละเอียดผู้ป่วยประจำวัน",
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
              '  ยังไม่มีผู้ใช้มาทำ\nการบันทึกผลในวันนี้',
              style: GoogleFonts.prompt(fontSize: 20),
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
                            builder: (context) => DailyDetailsAdminScreen(
                                userId: users[index].id!),
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

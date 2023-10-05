import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DailyUserDetailAdminScreen extends StatefulWidget {
  final DocumentSnapshot patientData;

  DailyUserDetailAdminScreen({required this.patientData});

  @override
  _DailyUserDetailAdminScreenState createState() =>
      _DailyUserDetailAdminScreenState();
}

class _DailyUserDetailAdminScreenState
    extends State<DailyUserDetailAdminScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> resultsStream;

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    resultsStream = _getAllResultsForUser();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getAllResultsForUser() {
    return FirebaseFirestore.instance
        .collection('checkResults')
        .where('userID', isEqualTo: widget.patientData['userID'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "รายละเอียดคนไข้",
          style: GoogleFonts.prompt(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red[300],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: resultsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No records found for the user.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child:
                          _buildRecordItem(snapshot.data!.docs[index].data()),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> data) {
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate().toLocal();

    // Convert only the year to Thai Buddhist year
    DateTime thaiDate = DateTime(dateTime.year + 543, dateTime.month,
        dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

    String formattedDate = DateFormat.yMd('th_TH').add_jm().format(thaiDate);

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(data['userID']).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final name = "${userData['firstName']} ${userData['lastName']}";

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (data['imageUrl'] != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            data['imageUrl'],
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "ชื่อ : $name",
                      style: GoogleFonts.prompt(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "อุณหภูมิ : ${data['temperature']}°C",
                      style: GoogleFonts.prompt(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "น้ำหนัก : ${data['weight']}kg",
                      style: GoogleFonts.prompt(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "ผลตรวจ : ${data['result']}",
                      style: GoogleFonts.prompt(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "เวลาที่บันทึก : $formattedDate",
                      style: GoogleFonts.prompt(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

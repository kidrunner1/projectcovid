import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import this at the top of your file

class UserDetailScreen extends StatefulWidget {
  final DocumentSnapshot patientData;

  UserDetailScreen({required this.patientData});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> resultsStream;

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
                final data = snapshot.data!.docs[index].data();
                return _buildRecordItem(data);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> data) {
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();

    // Convert to Thai Buddhist year by adding 543 years
    DateTime thaiDate = dateTime.add(Duration(days: (543 * 365.25).round()));

    String formattedDate = DateFormat.yMMMMd('th_TH').add_jm().format(thaiDate);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (data['imageUrl'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    data['imageUrl'],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              Text(
                "Temperature: ${data['temperature']}°C",
                style: GoogleFonts.prompt(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Weight: ${data['weight']}kg",
                style: GoogleFonts.prompt(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Result: ${data['result']}",
                style: GoogleFonts.prompt(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "เวลาที่บันทึก : $formattedDate",
                style: GoogleFonts.prompt(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

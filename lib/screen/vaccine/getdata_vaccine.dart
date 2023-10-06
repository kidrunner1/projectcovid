import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class GetData_Vaccine extends StatefulWidget {
  final Map<String, dynamic> getappoints;
  const GetData_Vaccine({Key? key, required this.getappoints})
      : super(key: key);

  @override
  GetData_VaccineState createState() => GetData_VaccineState();
}

class GetData_VaccineState extends State<GetData_Vaccine> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userData;
  Map<String, dynamic>? appointmentData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final userID = widget.getappoints['userID'];
    if (userID != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();
      print("Fetched user data: ${userDoc.data()}"); // Check the fetched data
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>;
      });
    } else {
      print(
          "No userID found in getappoints."); // This will let you know if the userID isn't passed correctly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(
          'รายละเอียดการนัดฉีดวัคซีน',
          style: GoogleFonts.prompt(fontSize: 22),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('vaccine_detail')
            .doc(_auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(child: Text('No vaccination details found'));
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${data['vaccineRound']}",
                    style: GoogleFonts.prompt(fontSize: 18)),
                Text("${data['username']}",
                    style: GoogleFonts.prompt(fontSize: 18)),
                Text("ชื่อวัคซีน : ${data['vaccineName']}",
                    style: GoogleFonts.prompt(fontSize: 18)),
                Text("วันที่ : ${data['vaccineDate']}",
                    style: GoogleFonts.prompt(fontSize: 18)),
                Text("เวลา : ${data['vaccineTime']}",
                    style: GoogleFonts.prompt(fontSize: 18)),
                Text("Location: ${data['vaccineLocation']}",
                    style: GoogleFonts.prompt(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}

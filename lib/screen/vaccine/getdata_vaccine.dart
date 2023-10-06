import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final userID = widget.getappoints['userID'];
    if (userID != null) {
      // Fetching documents based on the 'userID' field
      QuerySnapshot vaccineDetailSnapshot = await _firestore
          .collection('vaccine_detail')
          .where('userID', isEqualTo: userID)
          .get();

      if (vaccineDetailSnapshot.docs.isNotEmpty) {
        DocumentSnapshot vaccineDetailDoc = vaccineDetailSnapshot.docs.first;
        print("Fetched vaccine details: ${vaccineDetailDoc.data()}");
        setState(() {
          userData = vaccineDetailDoc.data() as Map<String, dynamic>;
        });
      } else {
        print(
            "No document found for userID: $userID in vaccine_detail collection");
      }
    } else {
      print("No userID found in getappoints.");
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
        body: userData == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("รอบ: ${userData!['vaccineRound'] ?? 'Not available'}",
                        style: GoogleFonts.prompt(fontSize: 18)),
                    Text(
                        "ชื่อ - นามสกุล: ${userData!['username'] ?? 'Not available'}",
                        style: GoogleFonts.prompt(fontSize: 18)),
                    Text(
                        "รหัสประจำตัวประชาชน: ${userData!['ID card'] ?? 'Not available'}",
                        style: GoogleFonts.prompt(fontSize: 18)),
                    Text(
                        "เบอร์โทรศัพท์: ${userData!['telephone number'] ?? 'Not available'}",
                        style: GoogleFonts.prompt(fontSize: 18)),
                    Text(
                        "Vaccine Name: ${userData!['vaccineName'] ?? 'Not available'}",
                        style: GoogleFonts.prompt(fontSize: 18)),
                    Text(
                        "Vaccine Date: ${userData!['vaccineDate'] ?? 'Not available'}",
                        style: GoogleFonts.prompt(fontSize: 18)),
                    Text(
                        "Vaccine Time: ${userData!['vaccineTime'] ?? 'Not available'}",
                        style: GoogleFonts.prompt(fontSize: 18)),
                    Text(
                        "Location: ${userData!['vaccineLocation'] ?? 'Not available'}",
                        style: GoogleFonts.prompt(fontSize: 18)),
                  ],
                ),
              ));
  }
}

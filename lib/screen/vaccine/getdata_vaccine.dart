import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent[700],
        title: Text(
          'รายละเอียดวัคซีน',
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Lottie.asset(
                'assets/animations/vaccine.json',
                repeat: true,
                animate: true,
              ),
            ),
            Expanded(
              child: userData == null
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView(
                        children: [
                          _dataCard('รอบ', userData!['vaccineRound']),
                          _dataCard('ชื่อ - นามสกุล', userData!['username']),
                          _dataCard(
                              'รหัสประจำตัวประชาชน', userData!['ID card']),
                          _dataCard(
                              'เบอร์โทรศัพท์', userData!['telephone number']),
                          _dataCard('ชื่อวัคซีน', userData!['vaccineName']),
                          _dataCard('วันที่', userData!['vaccineDate']),
                          _dataCard('เวลา', userData!['vaccineTime']),
                          _dataCard('สถานที่', userData!['vaccineLocation']),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataCard(String title, dynamic data) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent[100]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.deepPurpleAccent[700],
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            data ?? 'Not available',
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      //backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(
          'รายละเอียดการนัดฉีดวัคซีน',
          style: GoogleFonts.prompt(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: AnimatedOpacity(
          opacity: userData == null ? 0.0 : 1.0,
          duration: Duration(seconds: 2),
          child: Container(
            child: userData == null
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildHeader(),
                        const SizedBox(height: 20),
                        buildCard(buildVaccineDetails()),
                        const SizedBox(height: 20),
                        buildCard(buildUserDetails(userData!)),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/images/logo_hospital.png', height: 150),
          const SizedBox(height: 10),
          Text("โรงพยาบาลสกลนคร",
              style: GoogleFonts.prompt(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 48, 110, 50),
              )),
          Text("SAKON NAKHON HOSPITAL",
              style: GoogleFonts.prompt(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 48, 110, 50),
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildCard(Widget child) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: child,
      ),
    );
  }

  Widget buildVaccineDetails() {
    return Column(
      children: [
        Text("รอบ: ${userData!['vaccineRound'] ?? 'Not available'}",
            style: GoogleFonts.prompt(fontSize: 18)),
        Text("------------------------------",
            style: GoogleFonts.prompt(
              fontSize: 23,
              color: Colors.black,
            )),
        Text("รายละเอียด",
            style: GoogleFonts.prompt(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        const SizedBox(height: 5),
        Text("Sinavac(เข็มที่ 1) + AstraZeneca(เข็มที่ 2)",
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            )),
        Text("20 มกราคม 2567",
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            )),
        Text("เวลา : 09.00 น. เป็นต้นไป",
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            )),
        Text("สถานที่ฉีด : โรงพยาบาลศูนย์สกลนคร",
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            )),
        const SizedBox(height: 10),
        Text("***** จำกัดสิทธิ์แค่ 120 คน *****",
            style: GoogleFonts.prompt(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            )),
        const SizedBox(height: 10),
        Image.asset('assets/images/vaccine.jpg', height: 150),
      ],
    );
  }

  Widget buildUserDetails(Map<String, dynamic> userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        dataRow("รอบ   :", userData['vaccineRound'] ?? 'Not available'),
        dataRow("ชื่อ - นามสกุล:", userData['username'] ?? 'Not available'),
        dataRow("รหัสประจำตัวประชาชน:", userData['ID card'] ?? 'Not available'),
        dataRow(
            "เบอร์โทรศัพท์:", userData['telephone number'] ?? 'Not available'),
        dataRow("ชื่อวัคซีน:", userData['vaccineName'] ?? 'Not available'),
        dataRow("วันที่:", userData['vaccineDate'] ?? 'Not available'),
        dataRow("เวลา:", userData['vaccineTime'] ?? 'Not available'),
        dataRow("สถานที่:", userData['vaccineLocation'] ?? 'Not available'),
      ],
    );
  }

  Widget dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style:
                  GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: GoogleFonts.prompt(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

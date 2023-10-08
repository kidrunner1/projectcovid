import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/vaccine/historyr_vaccine.dart';

class VaccineDetailsPage extends StatefulWidget {
  final Map<String, dynamic> vaccineData;

  VaccineDetailsPage({required this.vaccineData});

  @override
  _VaccineDetailsPageState createState() => _VaccineDetailsPageState();
}

class _VaccineDetailsPageState extends State<VaccineDetailsPage> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(
          'รายละเอียดการนัดฉีดวัคซีน',
          style: GoogleFonts.prompt(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(),
            const SizedBox(height: 20),
            buildCard(buildVaccineDetails()),
            const SizedBox(height: 20),
            buildCard(buildUserDetails(widget.vaccineData)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: confirmAppointment,
              child: Text('ยืนยันการฉีดวัคซีน',
                  style: GoogleFonts.prompt(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red[300], shape: StadiumBorder()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirmAppointment() async {
    try {
      // Add the appointment to the vaccineHistory collection
      await _firestore.collection('vaccineHistory').add(widget.vaccineData);

      // Remove the appointment from the vaccine_detail collection
      await _firestore
          .collection('vaccine_detail')
          .doc(widget.vaccineData['id'])
          .delete();

      // Navigate to the HisToryVaccineAdmin page
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HisToryVaccineAdmin()));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming appointment: $error')),
      );
    }
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
        Text("รอบ: ${widget.vaccineData['vaccineRound'] ?? 'Not available'}",
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

  Widget buildUserDetails(Map<String, dynamic> vaccineData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        dataRow("รอบ   :", vaccineData['vaccineRound'] ?? 'Not available'),
        dataRow("ชื่อ - นามสกุล:", vaccineData['username'] ?? 'Not available'),
        dataRow(
            "รหัสประจำตัวประชาชน:", vaccineData['ID card'] ?? 'Not available'),
        dataRow("เบอร์โทรศัพท์:",
            vaccineData['telephone number'] ?? 'Not available'),
        dataRow("ชื่อวัคซีน:", vaccineData['vaccineName'] ?? 'Not available'),
        dataRow("วันที่:", vaccineData['vaccineDate'] ?? 'Not available'),
        dataRow("เวลา:", vaccineData['vaccineTime'] ?? 'Not available'),
        dataRow("สถานที่:", vaccineData['vaccineLocation'] ?? 'Not available'),
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

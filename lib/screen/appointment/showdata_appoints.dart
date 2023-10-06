// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/appointment/getdata_appoints.dart';
import 'package:tracker_covid_v1/screen/vaccine/getdata_vaccine.dart';

class Showdata_appoints extends StatefulWidget {
  @override
  _ShowdataState createState() => _ShowdataState();
}

class _ShowdataState extends State<Showdata_appoints> {
  Stream<QuerySnapshot>? _stream;
  Stream<QuerySnapshot>? _vaccineDetailStream;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _stream = FirebaseFirestore.instance
          .collection('appointments')
          .where('userID', isEqualTo: userId)
          .orderBy('date',
              descending: true) // Most recent appointments at the top
          .snapshots();

      _vaccineDetailStream = FirebaseFirestore.instance
          .collection('vaccine_detail')
          .where('userID', isEqualTo: userId)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      primaryColor: Colors.red[300],
      backgroundColor: Colors.pink[50],
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "การนัดหมาย",
            style: GoogleFonts.prompt(),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: theme.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("มีบางอย่างผิดพลาด"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final appointmentDocs = snapshot.data?.docs ?? [];

              return StreamBuilder<QuerySnapshot>(
                stream: _vaccineDetailStream,
                builder: (context, vaccineDetailSnapshot) {
                  final vaccineDocs = vaccineDetailSnapshot.data?.docs ?? [];
                  final allDocs = [...appointmentDocs, ...vaccineDocs];

                  return ListView.builder(
                    itemCount: allDocs.length,
                    itemBuilder: (context, index) {
                      final data =
                          allDocs[index].data() as Map<String, dynamic>;
                      if (index < appointmentDocs.length) {
                        // This is an appointment doc
                        return _buildAppointmentCard(context, data);
                      } else {
                        // This is a vaccine detail doc
                        return _buildVaccineDetailCard(context, data);
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
        backgroundColor: Colors.red[50],
      ),
    );
  }
}

Widget _buildAppointmentCard(BuildContext context, Map<String, dynamic> data) {
  return Card(
    margin: const EdgeInsets.only(bottom: 20),
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      leading: const Icon(
        Icons.calendar_month,
        size: 40,
        color: Colors.black,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: Text('การติดต่อเข้ารับยา', style: GoogleFonts.prompt()),
      subtitle: Text('วันที่: ${data['date']}\nเวลา: ${data['time']}',
          style: GoogleFonts.prompt()),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GetdataAppoints(getappoints: data),
          ),
        );
      },
    ),
  );
}

Widget _buildVaccineDetailCard(
    BuildContext context, Map<String, dynamic> data) {
  return Card(
    margin: const EdgeInsets.only(bottom: 20),
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      leading: const Icon(
        Icons.medical_services_outlined,
        size: 40,
        color: Colors.black,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: Text('รายละเอียดการฉีดวัคซีน', style: GoogleFonts.prompt()),
      subtitle: Text(
          'รอบที่: ${data['vaccineRound']}\nชื่อวัคซีน: ${data['vaccineName']}\nวันที่: ${data['vaccineDate']}\nเวลา: ${data['vaccineTime']}',
          style: GoogleFonts.prompt()),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GetData_Vaccine(
              getappoints: data,
            ), // Pushing to the VaccineDetailsPage
          ),
        );
      },
    ),
  );
}

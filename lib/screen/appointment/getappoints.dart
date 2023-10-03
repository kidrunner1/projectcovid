import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/appointment/showdata_appoints.dart';

class GetAppoints extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> fetchUserData() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser?.uid).get();
    return userDoc.data() as Map<String, dynamic>?;
  }

Future<Map<String, dynamic>?> fetchAppointmentData() async {
    final appointmentDoc = await FirebaseFirestore.instance.collection('appointments')
        .where('userID', isEqualTo: _auth.currentUser?.uid)
        .orderBy('date')  // Assuming 'date' is stored as a string in the format YYYY-MM-DD.
        .orderBy('time')
        .limit(1)
        .get();

    if (appointmentDoc.docs.isNotEmpty) {
      return appointmentDoc.docs.first.data() as Map<String, dynamic>?;
    }
    return null;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดการนัดรับยา"),
        elevation: 0,
        backgroundColor: Colors.red[300],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.pink[50],
      body: Center(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: fetchUserData(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.done && userSnapshot.hasData) {
              return FutureBuilder<Map<String, dynamic>?>(
                future: fetchAppointmentData(),
                builder: (context, appointmentSnapshot) {
                  if (appointmentSnapshot.connectionState == ConnectionState.done) {
                    if (appointmentSnapshot.hasData) {
                      final mergedData = {
                        ...userSnapshot.data!,
                        ...appointmentSnapshot.data!
                      };
                      return ScreenGetappoints(getdata: mergedData);
                    }
                    return const Text("No appointment found");
                  }
                  return const CircularProgressIndicator();
                },
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}


class ScreenGetappoints extends StatelessWidget {
  final Map<String, dynamic>? getdata;
  const ScreenGetappoints({this.getdata});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "คุณ ${getdata?['firstName']?? 'Not available'} ${getdata?['lastName']}",
                      style: GoogleFonts.prompt(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "วันที่เข้ารับยา : ${getdata?['date'] ?? 'Not available'}",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "เวลา : ${getdata?['time'] ?? 'Not available'}",
                       style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "สถานที่ : ${getdata?['hospital'] ?? 'Not available'}",
                       style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    AnimatedButton(
                      text: 'ปิด',
                      color: Colors.blueGrey,
                      pressEvent: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Showdata_appoints(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

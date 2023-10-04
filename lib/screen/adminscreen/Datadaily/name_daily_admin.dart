import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Datadaily/detail_daily.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientDetailScreen extends StatelessWidget {
  final List<DocumentSnapshot> patientDataList;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  PatientDetailScreen({required this.patientDataList});

  @override
  Widget build(BuildContext context) {
    // Set to store IDs of users we've already added to the list
    final addedUserIds = <String>{};
    final uniquePatients = patientDataList.where((patientData) {
      final userId = patientData['userID'];
      if (!addedUserIds.contains(userId)) {
        addedUserIds.add(userId);
        return true;
      }
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[200], // Provides a subtle background color
      appBar: AppBar(
        title: Text(
          "รายชื่อคนไข้",
          style: GoogleFonts.prompt(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4.0, // Slight elevation
        backgroundColor: Colors.red[300],
      ),

      body: ListView.builder(
        itemCount: uniquePatients.length,
        itemBuilder: (context, index) {
          final patientData = uniquePatients[index];

          return FutureBuilder<DocumentSnapshot>(
            future: users.doc(patientData['userID']).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return ListTile(
                    leading: const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 24),
                    title: Text(
                      "Error: ${snapshot.error}",
                      style: GoogleFonts.prompt(
                          fontSize: 18, color: Colors.redAccent),
                    ),
                  );
                }

                final userData = snapshot.data!;
                final name = "${userData['firstName']} ${userData['lastName']}";

                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red[300],
                      child: Text(
                        name.split(" ").map((str) => str[0]).join(),
                        style: GoogleFonts.prompt(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                    title: Text(
                      name,
                      style: GoogleFonts.prompt(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.red[300],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyUserDetailAdminScreen(
                            patientData: patientData,
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Envaluate/details_envaluate_admin.dart';

class GetDataDailysAdminScreen extends StatelessWidget {
  final String date;
  final List<QueryDocumentSnapshot> evaluations;

  GetDataDailysAdminScreen({required this.date, required this.evaluations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ข้อมูลของอาการวันที่ $date',
          style: GoogleFonts.prompt(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: evaluations.length,
          itemBuilder: (context, index) {
            var evalDoc = evaluations[index];
            var firstName =
                evalDoc['userID']; // Assuming you have a 'firstName' field
            var lastName =
                evalDoc['userID']; // Assuming you have a 'lastName' field

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              elevation: 10,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: Icon(Icons.person, color: Colors.deepPurple, size: 35),
                ),
                title: Text(
                  '$firstName $lastName',
                  style: GoogleFonts.prompt(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserDetailScreen(userDocument: evalDoc),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Envaluate/details_envaluate_admin.dart';

class GetDataEnvaluateAdminScreen extends StatelessWidget {
  final String date;
  final List<QueryDocumentSnapshot> evaluations;

  GetDataEnvaluateAdminScreen({required this.date, required this.evaluations});

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data() as Map<String, dynamic>;
  }

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
        backgroundColor: Colors.red[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: evaluations.length,
          itemBuilder: (context, index) {
            var evalDoc = evaluations[index];
            var userId = evalDoc[
                'userID']; // Assuming you store user ID in the evaluation document

            return FutureBuilder<Map<String, dynamic>>(
              future: fetchUserData(userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var firstName = snapshot.data!['firstName'];
                var lastName = snapshot.data!['lastName'];

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
                      backgroundColor: Colors.red[100],
                      child:
                          Icon(Icons.person, color: Colors.red[300], size: 35),
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
            );
          },
        ),
      ),
    );
  }
}

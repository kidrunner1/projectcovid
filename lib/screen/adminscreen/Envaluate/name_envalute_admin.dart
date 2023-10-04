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
          'รายชื่อคนไข้ที่ประเมินอาการ',
          style: GoogleFonts.prompt(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Colors.red[300],
        centerTitle: true,
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
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red[300],
                      child: Text(
                          '${firstName[0]}${lastName[0]}', // Extract the first letters of the names here
                          style: GoogleFonts.prompt(
                              color: Colors.white, fontSize: 20)),
                    ),
                    title: Text(
                      '$firstName $lastName',
                      style: GoogleFonts.prompt(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
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

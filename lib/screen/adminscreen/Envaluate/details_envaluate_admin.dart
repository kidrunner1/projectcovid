import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class UserDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot userDocument;

  UserDetailScreen({required this.userDocument});

  Future<Map<String, dynamic>> fetchUserData(String email) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return doc.docs.first.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    var email = userDocument['email'];
    var symptoms = userDocument['symptoms'];

    // Convert the 'date' which is a String to a DateTime object
    DateTime date = DateTime.parse(userDocument['date']);
    DateTime thaiDate = DateTime(date.year + 543, date.month, date.day);

    String formattedDate = DateFormat.yMd('th_TH').format(thaiDate);

    List<String> symptomList =
        symptoms.keys.where((key) => symptoms[key] == "Y").toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "รายละเอียดของการประเมินอาการ",
          style: GoogleFonts.prompt(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red[300],
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(email),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var firstName = snapshot.data!['firstName'];
          var lastName = snapshot.data!['lastName'];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.red[300],
                        child: const Icon(
                          FontAwesomeIcons.person,
                          color: Colors.white,
                          size: 60,
                        )),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$firstName $lastName',
                            style: GoogleFonts.prompt(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[300],
                            ),
                          ),
                          Text(
                            'รายละเอียดอาการของ',
                            style: GoogleFonts.prompt(
                              fontSize: 16,
                              color: Colors.red[300],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                Text("วันเวลาที่บันทึก : $formattedDate",
                    style: GoogleFonts.prompt(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300])),
                const SizedBox(height: 15),
                Text('อาการ:',
                    style: GoogleFonts.prompt(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[300])),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: symptomList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Text(
                          symptomList[index],
                          style: GoogleFonts.prompt(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

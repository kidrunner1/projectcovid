import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    List<String> symptomList =
        symptoms.keys.where((key) => symptoms[key] == "Y").toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียดของการประเมินอาการ",
            style: GoogleFonts.prompt(
                fontSize: 20.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red[300],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(email),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var firstName = snapshot.data!['firstName'];
          var lastName = snapshot.data!['lastName'];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('รายละเอียดอาการของ : \n$firstName $lastName',
                    style: GoogleFonts.prompt(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple)),
                SizedBox(height: 25),
                Text('อาการ:',
                    style: GoogleFonts.prompt(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple)),
                SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: symptomList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(symptomList[index],
                            style: GoogleFonts.prompt(
                                fontSize: 20, color: Colors.black54)),
                      );
                    },
                  ),
                ),
                // Add more details as needed here
              ],
            ),
          );
        },
      ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/appointment/getdata_appoints.dart';

class Showdata_appoints extends StatefulWidget {
  @override
  _Showdata_appointsState createState() => _Showdata_appointsState();
}

class _Showdata_appointsState extends State<Showdata_appoints> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
      primaryColor: Colors.red[300],
      hintColor: Colors.deepPurpleAccent,
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("การนัดหมาย"),
          elevation: 0,
          centerTitle: true,
          backgroundColor: theme.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("appointments")
                .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("มีบางอย่างผิดพลาด"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(
                  child: Text(
                    "ว่าง",
                    style: TextStyle(fontSize: 25),
                  ),
                );
              }
return ListView.builder(
  itemCount: docs.length,
  itemBuilder: (BuildContext context, int index) {
    DocumentSnapshot doc = docs[index];

    // Check if the document data is not null
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return Container(); // Return an empty container if data is null
    }

    String date = data['date'] ?? "Unknown Date";
    String firstName = data['first_name'] ?? "Unknown";
    String lastName = data['last_name'] ?? "";
    String time = data['time'] ?? "Unknown Time";

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: ListTile(
          title: Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Text("$firstName $lastName at $time"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GetdataAppoints(
                  getappoints: data,
                ),
              ),
            );
          },
        ),
      ),
    );
  },
);

            },
          ),
        ),
      ),
    );
  }
}

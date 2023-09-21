import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/check_covid/form_check.dart';
import 'package:tracker_covid_v1/screen/check_covid/getdata_check.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsCheckScreen extends StatefulWidget {
  @override
  _DetailsCheckScreenState createState() => _DetailsCheckScreenState();
}

class _DetailsCheckScreenState extends State<DetailsCheckScreen> {
  Stream<QuerySnapshot>? _stream;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _stream = FirebaseFirestore.instance
          .collection('checkResults')
          .where('userID', isEqualTo: userId)
          .orderBy('createdAt',
              descending: false) // This orders the results by the timestamp
          .snapshots();
    }
  }

  String _ordinal(int n) {
    if (n == 1) return "1";
    if (n == 2) return "2";
    if (n == 3) return "3";
    return "${n}";
  }

  @override
  Widget build(BuildContext context) {
    // Theme customization
    final theme = Theme.of(context).copyWith(
      textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
      primaryColor: Colors.red[300],
      hintColor: Colors.deepPurpleAccent,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurpleAccent,
      ),
      iconTheme: IconThemeData(color: Colors.pink[50]),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ผลตรวจโควิด-19 ประจำวัน"),
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
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(
                    child: Text(
                  "กรุณาทำการบันทึก\nผลตรวจประจำวัน",
                  style: TextStyle(fontSize: 25),
                ));
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      title: Text(
                        'บันทึกครั้งที่  ${_ordinal(index + 1)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetDataCheckScreen(
                                data:
                                    docs[index].data() as Map<String, dynamic>),
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
        backgroundColor: Colors.pink[50],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => FormCheck()));
          },
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}

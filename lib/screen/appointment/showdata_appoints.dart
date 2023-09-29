// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/appointment/getdata_appoints.dart';
import 'package:google_fonts/google_fonts.dart';

class Showdata_appoints extends StatefulWidget {
  @override
  _ShowdataState createState() => _ShowdataState();
}

class _ShowdataState extends State<Showdata_appoints> {
  Stream<QuerySnapshot>? _stream;

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
          title: const Text("การนัดหมาย"),
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
                    "ไม่มีรายการนัดหมาย",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      title: const Text(
                        'การติดต่อเข้ารับยา',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'วันที่: ${data['date']}\nเวลา: ${data['time']}', // Date and time as subtopics
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GetdataAppoints(getappoints: data),
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
        backgroundColor: Colors.red[50],
      ),
    );
  }
}

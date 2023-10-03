import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Envaluate/envaluate_admin.dart';

class GetEnvaluateAdminScreen extends StatefulWidget {
  const GetEnvaluateAdminScreen({super.key});

  @override
  State<GetEnvaluateAdminScreen> createState() =>
      _GetEnvaluateAdminScreenState();
}

class _GetEnvaluateAdminScreenState extends State<GetEnvaluateAdminScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประเมินอาการประจำวัน',
          style: GoogleFonts.prompt(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        backgroundColor: Colors.red[300],
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('evaluate_symptoms')
            .orderBy('date')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Grouping data by date
          Map<String, List<QueryDocumentSnapshot>> groupedData = {};
          for (var doc in snapshot.data!.docs) {
            String date = doc['date'];
            if (!groupedData.containsKey(date)) {
              groupedData[date] = [];
            }
            groupedData[date]!.add(doc);
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: groupedData.keys.length,
              itemBuilder: (context, index) {
                String date = groupedData.keys.elementAt(index);
                var evaluations = groupedData[date]!;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 10,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GetDataEnvaluateAdminScreen(
                              date: date, evaluations: evaluations),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(25.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('บันทึกวันที่: $date',
                          style: GoogleFonts.prompt(
                              fontWeight: FontWeight.w600, fontSize: 20.0)),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

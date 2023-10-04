import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Datadaily/name_daily_admin.dart'; // Ensure the path is correct

class GetDataDailysAdminScreen extends StatefulWidget {
  const GetDataDailysAdminScreen({super.key});

  @override
  State<GetDataDailysAdminScreen> createState() =>
      _GetDataDailysAdminScreenState();
}

class _GetDataDailysAdminScreenState extends State<GetDataDailysAdminScreen> {
  // Reference to Firestore collection
  final CollectionReference checkResults =
      FirebaseFirestore.instance.collection('checkResults');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "ข้อมูลผลตรวจประจำวัน",
          style: GoogleFonts.prompt(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red[300],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: checkResults.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Group by date
          Map<DateTime, List<DocumentSnapshot>> groupedData = {};
          for (var doc in snapshot.data!.docs) {
            DateTime date = DateTime.fromMillisecondsSinceEpoch(
                    doc["timestamp"].millisecondsSinceEpoch)
                .toLocal();
            date = DateTime(date.year, date.month, date.day); // Removing time
            if (!groupedData.containsKey(date)) {
              groupedData[date] = [];
            }
            groupedData[date]!.add(doc);
          }

          // Sort the dates in descending order (most recent first)
          var sortedDates = groupedData.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              DateTime date = sortedDates[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  leading: Icon(Icons.calendar_today,
                      size: 50,
                      color: Colors.red[300]), // Adding calendar icon here
                  title: Text(
                    "บันทึกวันที่",
                    style: GoogleFonts.prompt(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  subtitle: Text(
                    "${date.day}/${date.month}/${date.year}",
                    style: GoogleFonts.prompt(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.red[300],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailScreen(
                            patientDataList: groupedData[date]!),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

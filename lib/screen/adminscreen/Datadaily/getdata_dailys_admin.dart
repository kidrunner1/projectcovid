import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Datadaily/name_daily_admin.dart'; // Ensure the path is correct
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GetDataDailysAdminScreen extends StatefulWidget {
  const GetDataDailysAdminScreen({super.key});

  @override
  State<GetDataDailysAdminScreen> createState() =>
      _GetDataDailysAdminScreenState();
}

class _GetDataDailysAdminScreenState extends State<GetDataDailysAdminScreen> {
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
        elevation: 4,
        backgroundColor: Colors.red[300],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: checkResults.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Map<DateTime, List<DocumentSnapshot>> groupedData = {};
          for (var doc in snapshot.data!.docs) {
            DateTime date = DateTime.fromMillisecondsSinceEpoch(
                    doc["timestamp"].millisecondsSinceEpoch)
                .toLocal();
            date = DateTime(date.year, date.month, date.day);
            if (!groupedData.containsKey(date)) {
              groupedData[date] = [];
            }
            groupedData[date]!.add(doc);
          }

          var sortedDates = groupedData.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return AnimationLimiter(
            child: ListView.builder(
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                DateTime date = sortedDates[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          leading: Icon(Icons.calendar_today,
                              size: 50, color: Colors.red[300]),
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
                      ),
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

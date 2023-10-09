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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientDetailScreen(
                                      patientDataList: groupedData[date]!),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(15.0),
                            splashColor: Colors.blue.withAlpha(30),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.red.shade900,
                                    Colors.red[300]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                leading: Icon(Icons.calendar_today,
                                    color: Colors.white, size: 30),
                                title: Text(
                                  "บันทึกวันที่ \n${date.day}/${date.month}/${date.year}",
                                  style: GoogleFonts.prompt(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    size: 20, color: Colors.white),
                              ),
                            ),
                          ),
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

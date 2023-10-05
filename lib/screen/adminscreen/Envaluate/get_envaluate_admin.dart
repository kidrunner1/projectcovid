import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Envaluate/name_envalute_admin.dart';

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
        elevation: 0.0,
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

          return AnimationLimiter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: groupedData.keys.length,
                itemBuilder: (context, index) {
                  String dateStr = groupedData.keys.elementAt(index);
                  var evaluations = groupedData[dateStr]!;

                  DateTime? dateObj =
                      tryParseDate(dateStr); // Use the new function here
                  if (dateObj == null) {
                    print("Unable to parse date: $dateStr");
                    return Text("Invalid date format: $dateStr");
                  }

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
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
                              "${dateObj.day}/${dateObj.month}/${dateObj.year}",
                              style: GoogleFonts.prompt(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                                  builder: (context) =>
                                      GetDataEnvaluateAdminScreen(
                                          date: dateStr,
                                          evaluations: evaluations),
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
            ),
          );
        },
      ),
    );
  }

  DateTime? tryParseDate(String dateStr) {
    // Try parsing in the 'yyyy-mm-dd' format
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      // If the above parsing fails, try parsing in the 'dd-mm-yyyy' format
      List<String> dateComponents = dateStr.split('-');
      if (dateComponents.length == 3) {
        String formattedDateStr =
            '${dateComponents[2]}-${dateComponents[1]}-${dateComponents[0]}';
        try {
          return DateTime.parse(formattedDateStr);
        } catch (e) {
          print("Failed to parse date: $dateStr in both formats. Error: $e");
          return null;
        }
      }
    }
    return null;
  }
}

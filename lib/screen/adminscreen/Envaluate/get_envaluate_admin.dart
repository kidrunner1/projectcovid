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
      backgroundColor: Colors.grey[200],
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
            child: ListView.builder(
              itemCount: groupedData.keys.length,
              itemBuilder: (context, index) {
                String dateStr = groupedData.keys.elementAt(index);

                DateTime? dateObj = tryParseDate(dateStr);
                if (dateObj == null) {
                  return SizedBox
                      .shrink(); // If unable to parse, skip rendering this item
                }

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
                                  builder: (context) =>
                                      // Make sure the constructor of this screen accepts the right parameters
                                      GetDataEnvaluateAdminScreen(
                                          date: dateStr,
                                          evaluations: groupedData[dateStr]!),
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
                                  "บันทึกวันที่  \n${dateObj.day}/${dateObj.month}/${dateObj.year}",
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

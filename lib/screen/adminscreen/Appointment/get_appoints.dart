import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Appointment/details_medicin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Appointment/get_history.dart';

class GetDataAppointsAdmin extends StatefulWidget {
  const GetDataAppointsAdmin({super.key});

  @override
  State<GetDataAppointsAdmin> createState() => _GetDataAppointsAdminState();
}

class _GetDataAppointsAdminState extends State<GetDataAppointsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายการนัดรับยา',
          style: GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[300],
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GetAppointHistoryAdmin()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('appointments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final appointmentDocs = snapshot.data?.docs;

          return AnimationLimiter(
            child: ListView.builder(
              itemCount: appointmentDocs?.length,
              itemBuilder: (context, index) {
                final appointmentData =
                    appointmentDocs?[index].data() as Map<String, dynamic>;

                final userId = appointmentData['userID'] ?? 'N/A';

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
                                  builder: (context) => AppointmentDetailsPage(
                                    appointmentData: appointmentData,
                                    userId: userId,
                                  ),
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
                                leading: Icon(FontAwesomeIcons.stethoscope,
                                    color: Colors.white),
                                title: Text(
                                  'วันที่: ${appointmentData['date']} \nเวลา ${appointmentData['time']}',
                                  style: GoogleFonts.prompt(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  'Hospital: ${appointmentData['hospital']}',
                                  style: GoogleFonts.prompt(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
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

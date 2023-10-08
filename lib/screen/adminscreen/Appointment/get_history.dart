import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GetAppointHistoryAdmin extends StatefulWidget {
  const GetAppointHistoryAdmin({super.key});

  @override
  State<GetAppointHistoryAdmin> createState() => _GetAppointHistoryAdminState();
}

class _GetAppointHistoryAdminState extends State<GetAppointHistoryAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ยืนยันการนัดรับยา',
          style: GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[300],
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointmentHistory')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No confirmed appointments.'));
          }

          return AnimationLimiter(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final appointmentData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

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
                              trailing: Icon(Icons.verified,
                                  color: Colors.green,
                                  size: 30.0), // Added checkmark icon here
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

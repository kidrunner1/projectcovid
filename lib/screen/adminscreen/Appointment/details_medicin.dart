import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Appointment/get_history.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Map<String, dynamic> appointmentData;
  final String userId;

  const AppointmentDetailsPage({
    required this.appointmentData,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text(
          'รายละเอียดการนัดรับยา',
          style: GoogleFonts.prompt(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red[300],
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data available for the user.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final firstName = userData['firstName'] ?? 'N/A';
          final lastName = userData['lastName'] ?? 'N/A';
          final phoneNumber = userData['phoneNumber'] ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(height: 20.0),
                _infoTile(
                  icon: FontAwesomeIcons.calendarDay,
                  title: 'วันที่',
                  content: appointmentData['date'],
                ),
                _infoTile(
                  icon: FontAwesomeIcons.clock,
                  title: 'เวลา',
                  content: appointmentData['time'],
                ),
                _infoTile(
                  icon: FontAwesomeIcons.person,
                  title: 'ชื่อ นามสกุล',
                  content: '$firstName $lastName',
                ),
                _infoTile(
                  icon: FontAwesomeIcons.phone,
                  title: 'เบอร์โทรศัพท์',
                  content: phoneNumber,
                ),
                _infoTile(
                  icon: FontAwesomeIcons.hospital,
                  title: 'สถานที่',
                  content: appointmentData['hospital'],
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      // 1. Add this appointment to the confirmedAppointments collection
                      await FirebaseFirestore.instance
                          .collection('appointmentHistory')
                          .add(appointmentData);

                      // 2. Delete the appointment from the original appointments collection
                      await FirebaseFirestore.instance
                          .collection('appointments')
                          .doc(appointmentData['id'])
                          .delete();

                      // 3. Navigate to the GetAppointHistoryAdmin page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GetAppointHistoryAdmin()),
                      );
                    } catch (error) {
                      print("Error: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Error confirming appointment: $error')),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'ยืนยันการนัด',
                      style: GoogleFonts.prompt(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _headerContent(String header, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24.0, color: Colors.red[400]),
        SizedBox(width: 10.0),
        Text(
          header,
          style: GoogleFonts.prompt(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        elevation: 5,
        child: ListTile(
          contentPadding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          leading: Icon(icon, color: Colors.red[400], size: 30),
          title: Text(
            title,
            style: GoogleFonts.prompt(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            content,
            style: GoogleFonts.prompt(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

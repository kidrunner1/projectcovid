import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        title: _styledText('รายละเอียดการนัดรับยา', 20, FontWeight.bold),
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
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data available for the user.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return _content(context, userData);
        },
      ),
    );
  }

  Widget _content(BuildContext context, Map<String, dynamic> userData) {
    final firstName = userData['firstName'] ?? 'N/A';
    final lastName = userData['lastName'] ?? 'N/A';
    final phoneNumber = userData['phoneNumber'] ?? 'N/A';

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: [
          SizedBox(height: 5.0),
          Material(
            borderRadius: BorderRadius.circular(15.0),
            elevation: 5,
            child: Column(
              children: [
                _infoTile(FontAwesomeIcons.calendarDay, 'วันที่',
                    appointmentData['date']),
                const Divider(),
                _infoTile(
                    FontAwesomeIcons.clock, 'เวลา', appointmentData['time']),
                const Divider(),
                _infoTile(FontAwesomeIcons.person, 'ชื่อ นามสกุล',
                    '$firstName $lastName'),
                const Divider(),
                _infoTile(FontAwesomeIcons.phone, 'เบอร์โทรศัพท์', phoneNumber),
                const Divider(),
                _infoTile(FontAwesomeIcons.hospital, 'สถานที่',
                    appointmentData['hospital']),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () => _showConfirmationDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: _styledText('ยืนยันการนัด', 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _styledText(String text, double fontSize,
      [FontWeight fontWeight = FontWeight.normal]) {
    return Text(text,
        style: GoogleFonts.prompt(fontSize: fontSize, fontWeight: fontWeight));
  }

  Widget _infoTile(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(15.0),
        leading: Icon(icon, color: Colors.red[400], size: 30),
        title: _styledText(title, 18, FontWeight.bold),
        subtitle: _styledText(content, 16),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: _styledText('ยืนยันการนัด', 20),
        content: _styledText('คุณแน่ใจหรือไม่ว่าต้องการยืนยันการนัด?', 18),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: _styledText('ยกเลิก', 18),
          ),
          TextButton(
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

                // 3. Navigate to the GetAppointHistoryAdmin page and remove all previous routes
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetAppointHistoryAdmin(),
                  ),
                );
              } catch (error) {
                print("Error: $error");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Error confirming appointment: $error')),
                );
              }
            },
            child: _styledText('ยืนยัน', 18),
          ),
        ],
      ),
    );
  }
}

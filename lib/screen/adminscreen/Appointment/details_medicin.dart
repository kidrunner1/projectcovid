import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
      appBar: AppBar(
        title: Text('รายละเอียดการนัดรับยา', style: GoogleFonts.prompt()),
        backgroundColor: Colors.red[300],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
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
              child: AnimationLimiter(
                child: ListView(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      _infoTile(
                        context,
                        icon: FontAwesomeIcons.calendarDay,
                        title: 'วันที่นัดรับยา',
                        content: appointmentData['date'],
                      ),
                      _infoTile(
                        context,
                        icon: FontAwesomeIcons.clock,
                        title: 'เวลานัดรับยา',
                        content: appointmentData['time'],
                      ),
                      _infoTile(
                        context,
                        icon: FontAwesomeIcons.person,
                        title: 'ชื่อ - นามสกุล',
                        content: '$firstName $lastName',
                      ),
                      _infoTile(
                        context,
                        icon: FontAwesomeIcons.phone,
                        title: 'เบอร์โทรศัพท์',
                        content: phoneNumber,
                      ),
                      _infoTile(
                        context,
                        icon: FontAwesomeIcons.hospital,
                        title: 'โรงพยาล',
                        content: appointmentData['hospital'],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.red[50],
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          splashColor: Colors.lightBlueAccent,
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.white!, Colors.blueGrey[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.blueGrey, size: 30),
                SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.prompt(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[700],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        content,
                        style: GoogleFonts.prompt(
                            fontSize: 16, color: Colors.blueGrey[600]),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

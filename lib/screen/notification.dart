import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/check_covid/details_chek.dart';
import 'package:tracker_covid_v1/screen/evaluate_symptom/showdata_symptom.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Stream<List<NotificationItem>> notificationStream;

  @override
  void initState() {
    super.initState();
    notificationStream = getNotificationStream();
  }

  Stream<List<NotificationItem>> getNotificationStream() async* {
    String userId = "12345"; // replace this with fetching the current user's ID

    while (true) {
      bool recorded = await hasRecordedResultsToday(userId);
      List<NotificationItem> notifications = [];

      if (!recorded) {
        notifications = [
          NotificationItem(
            'วันนี้คุณยังไม่ได้ทำการ บันทึกผลตรวจประจำวัน.',
            NotificationType.DetailsCheckScreen,
          ),
          NotificationItem(
            'วันนี้คุณยังไม่ได้ทำการประเมินอาการประจำวัน',
            NotificationType.showdata_symptom,
          ),
        ];
      }

      yield notifications;

      // Pause the stream for the rest of the day, then recheck tomorrow
      final now = DateTime.now();
      final tomorrow =
          DateTime(now.year, now.month, now.day).add(Duration(days: 1));
      final timeUntilTomorrow = tomorrow.difference(now);
      await Future.delayed(timeUntilTomorrow);
    }
  }

  Future<bool> hasRecordedResultsToday(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final symptomsSnap = await FirebaseFirestore.instance
        .collection('evaluate_symptoms')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .get();

    final resultsSnap = await FirebaseFirestore.instance
        .collection('checkResults')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThanOrEqualTo: endOfDay)
        .get();

    return symptomsSnap.docs.isNotEmpty && resultsSnap.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 8,
        backgroundColor: Colors.red[300],
        title: Text(
          'การแจ้งเตือน',
          style: GoogleFonts.prompt(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<NotificationItem>>(
        stream: notificationStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<NotificationItem>? notifications = snapshot.data;

          return ListView.builder(
            itemCount: notifications?.length,
            itemBuilder: (context, index) {
              NotificationItem notification = notifications![index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red[300],
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    notification.message,
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    switch (notification.type) {
                      case NotificationType.DetailsCheckScreen:
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsCheckScreen(),
                          ),
                        );
                        break;
                      case NotificationType.showdata_symptom:
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => showdata_symptom(),
                          ),
                        );
                        break;
                    }
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

class NotificationItem {
  final String message;
  final NotificationType type;

  NotificationItem(this.message, this.type);
}

enum NotificationType {
  DetailsCheckScreen,
  showdata_symptom,
  // Add other types as needed
}

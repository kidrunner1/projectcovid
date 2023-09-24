import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class Recording {
  final Timestamp? createdAt;
  final String? imageUrl;
  final String? result;
  final String? temperature;
  final String? userId;
  final String? weight;

  Recording({
    this.createdAt,
    this.imageUrl,
    this.result,
    this.temperature,
    this.userId,
    this.weight,
  });

  factory Recording.fromDocument(DocumentSnapshot doc) {
    return Recording(
      createdAt: doc['createdAt'],
      imageUrl: doc['imageUrl'],
      result: doc['result'],
      temperature: doc['temperature'] as String?,
      userId: doc['userID'],
      weight: doc['weight'] as String?,
    );
  }
}

class DailyDetailsAdminScreen extends StatefulWidget {
  final String userId;

  const DailyDetailsAdminScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _DailyDetailsScreenState createState() => _DailyDetailsScreenState();
}

class _DailyDetailsScreenState extends State<DailyDetailsAdminScreen> {
  late Stream<List<Recording>> recordingsStream;

  @override
  void initState() {
    super.initState();
    recordingsStream = _getRecordingsStream();
  }

  Stream<List<Recording>> _getRecordingsStream() {
    return FirebaseFirestore.instance
        .collection('checkResults')
        .where('userID', isEqualTo: widget.userId)
        .snapshots()
        .map((snapshot) {
      List<Recording> recordings = [];
      for (var doc in snapshot.docs) {
        try {
          recordings.add(Recording.fromDocument(doc));
        } catch (e) {
          print("Error parsing document: ${doc.id}, $e");
        }
      }
      return recordings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "รายละเอียดการบันทึกข้อมูล",
          style: GoogleFonts.prompt(),
        ),
      ),
      body: StreamBuilder<List<Recording>>(
        stream: recordingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 20),
                  Text("Error fetching data: ${snapshot.error}"),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "ผู้ใช้นี้ยังไม่ได้ทำการบันทึกผลตรวจประจำวัน.",
                style: GoogleFonts.prompt(fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final recording = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: Column(
                    children: [
                      if (recording.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)), // Top rounded corners
                          child: Image.network(
                            recording.imageUrl!,
                            height: 150, // Larger Image
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        title: Text(
                            '${recording.result ?? "Unknown result"} - ${recording.temperature ?? "Unknown"}°C',
                            style: GoogleFonts.prompt(fontSize: 15)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'น้ำหนัก: ${recording.weight ?? "Unknown"}kg',
                                  style: GoogleFonts.prompt(fontSize: 15)),
                              SizedBox(height: 10),
                              Text(
                                  'วันที่: ${recording.createdAt?.toDate().toString() ?? "Unknown date"}',
                                  style: GoogleFonts.prompt(fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

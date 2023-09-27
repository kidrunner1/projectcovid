import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomsRecording {
  final Map<String, dynamic>? symptoms;
  final String? date;
  final String? time;

  SymptomsRecording({this.symptoms, this.date, this.time});

  factory SymptomsRecording.fromDocument(DocumentSnapshot doc) {
    return SymptomsRecording(
      symptoms: doc['symptoms'] as Map<String, dynamic>?,
      date: doc['date'] as String?,
      time: doc['time'] as String?,
    );
  }
}

class GetDataenvaluateScreen extends StatefulWidget {
  final String userId;

  GetDataenvaluateScreen({required this.userId, Key? key}) : super(key: key);

  @override
  _GetDataEnvaluateAdminScreenState createState() =>
      _GetDataEnvaluateAdminScreenState();
}

class _GetDataEnvaluateAdminScreenState extends State<GetDataenvaluateScreen> {
  late Stream<List<SymptomsRecording>> symptomsRecordingsStream;

  @override
  void initState() {
    super.initState();
    symptomsRecordingsStream = _getSymptomsRecordingsStream();
  }

  Stream<List<SymptomsRecording>> _getSymptomsRecordingsStream() {
    return FirebaseFirestore.instance
        .collection('evaluate_symptoms')
        .where('userID', isEqualTo: widget.userId)
        .snapshots()
        .map((snapshot) {
      List<SymptomsRecording> recordings = [];
      for (var doc in snapshot.docs) {
        try {
          recordings.add(SymptomsRecording.fromDocument(doc));
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
        backgroundColor: Colors.red[300],
        title: Text("Symptoms Details", style: GoogleFonts.prompt()),
      ),
      body: StreamBuilder<List<SymptomsRecording>>(
        stream: symptomsRecordingsStream,
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
                "ผู้ใช้ยังไม่ได้ทำการประเมินอาการประจำวัน",
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      'อาการ: ${_symptomsToString(recording.symptoms)}',
                      style: GoogleFonts.prompt(fontSize: 15),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'วันที่: ${recording.date ?? "Unknown date"}',
                            style: GoogleFonts.prompt(fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'เวลา: ${recording.time ?? "Unknown time"}',
                            style: GoogleFonts.prompt(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _symptomsToString(Map<String, dynamic>? symptoms) {
    if (symptoms == null) return "Unknown symptoms";
    return symptoms.keys.join(', ');
  }
}

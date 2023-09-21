import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: const Text(
          "รายละเอียดการบันทึกข้อมูล",
          style: TextStyle(fontWeight: FontWeight.bold),
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
            return const Center(
              child: Text(
                "No recordings found for this user.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final recording = snapshot.data![index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  title: Text(
                    '${recording.result ?? "Unknown result"} - ${recording.temperature ?? "Unknown"}°C',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weight: ${recording.weight ?? "Unknown"}kg',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Date: ${recording.createdAt?.toDate().toString() ?? "Unknown date"}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  leading: recording.imageUrl != null
                      ? CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(recording.imageUrl!),
                        )
                      : CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.deepPurple[100],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.deepPurple,
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
}

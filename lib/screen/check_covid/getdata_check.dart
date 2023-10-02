import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetDataCheckScreen extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> data;

  const GetDataCheckScreen({Key? key, required this.userId, required this.data})
      : super(key: key);

  @override
  _GetDataCheckScreenState createState() => _GetDataCheckScreenState();
}

class _GetDataCheckScreenState extends State<GetDataCheckScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> resultsStream;

  @override
  void initState() {
    super.initState();
    resultsStream = _getResultsForDate(
      (widget.data['createdAt'] as Timestamp).toDate(),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getResultsForDate(
      DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(microseconds: 1));

    return FirebaseFirestore.instance
        .collection('checkResults')
        .where('userID', isEqualTo: widget.userId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .where('createdAt', isLessThanOrEqualTo: endOfDay)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("รายละเอียดการบันทึกผล"),
          elevation: 0,
          backgroundColor: Colors.red[300],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: resultsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No records found for today.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snapshot.data!.docs[index].data();
                  return _buildRecordItem(data);
                },
              );
            }
          },
        ),
        backgroundColor: Colors.red[50],
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> data) {
    final Timestamp? createdAt = data['createdAt'];
    final String formattedDateTime = createdAt != null
        ? "${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year} ${createdAt.toDate().hour}:${createdAt.toDate().minute}"
        : 'Unknown Date and Time';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "วันและเวลาที่บันทึก : $formattedDateTime",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "น้ำหนักปุจจุบัน : ${data['weight'] ?? 'Not available'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "อุณหภูมิปัจจุบัน : ${data['temperature'] ?? 'Not available'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "ผลตรวจ ATK วันนี้ : ${data['result'] != null && data['result'].isNotEmpty ? data['result'] : 'No result available'}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "แนบผลการตรวจ ATK(รูปภาพ) : ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          data['imageUrl'] != null && data['imageUrl'].isNotEmpty
              ? Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    data['imageUrl'],
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print("Error fetching image: $error");
                      return const Center(
                        child: Text('Failed to load image.'),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    "No image available",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
        ],
      ),
    );
  }
}

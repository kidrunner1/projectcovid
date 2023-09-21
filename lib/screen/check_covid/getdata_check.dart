import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetDataCheckScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const GetDataCheckScreen({Key? key, required this.data}) : super(key: key);

  @override
  _GetDataCheckScreenState createState() => _GetDataCheckScreenState();
}

class _GetDataCheckScreenState extends State<GetDataCheckScreen> {
  @override
  Widget build(BuildContext context) {
    // Theme data to use custom fonts and other stylings.
    final theme = Theme.of(context).copyWith(
      textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
    );

    // Formatting the timestamp for display
    final Timestamp? timestamp = widget.data['timestamp'];
    final String formattedDateTime = timestamp != null
        ? "${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year} ${timestamp.toDate().hour}:${timestamp.toDate().minute}"
        : 'Unknown Date and Time';

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("รายละเอียดการบันทึกผล"),
          elevation: 0,
          backgroundColor: Colors.red[300],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "วันและเวลาที่บันทึก : $formattedDateTime",
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
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
                        "น้ำหนักปุจจุบัน : ${widget.data['weight'] ?? 'Not available'}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "อุณหภูมิปัจจุบัน : ${widget.data['temperature'] ?? 'Not available'}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "ผลตรวจ ATK วันนี้ : ${widget.data['result'] != null && widget.data['result'].isNotEmpty ? widget.data['result'] : 'No result available'}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("แนบผลการตรวจ ATK(รูปภาพ) : ",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              widget.data['imageUrl'] != null &&
                      widget.data['imageUrl'].isNotEmpty
                  ? Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        widget.data['imageUrl'],
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
                              child: Text('Failed to load image.'));
                        },
                      ),
                    )
                  : const Center(
                      child: Text("No image available",
                          style: TextStyle(color: Colors.grey))),
            ],
          ),
        ),
        backgroundColor: Colors.red[50],
      ),
    );
  }
}

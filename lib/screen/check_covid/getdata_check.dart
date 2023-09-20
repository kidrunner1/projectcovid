import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_covid_v1/screen/check_covid/details_chek.dart';

class GetDataCheckScreen extends StatefulWidget {
  const GetDataCheckScreen({Key? key, required  dataEntry})
      : super(key: key);

  @override
  State<GetDataCheckScreen> createState() => _GetDataCheckScreenState();
}

class _GetDataCheckScreenState extends State<GetDataCheckScreen> {
  late Stream<QuerySnapshot> _dataStream;

  @override
  void initState() {
    super.initState();
    _dataStream = FirebaseFirestore.instance
        .collection('checkResults')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Data Details"),
        backgroundColor: Colors.red[400],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Please record the information daily on the check form page.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var doc = documents[index];
              return Card(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text("Weight: ${doc['weight']}"),
                  subtitle: Text(
                      "Temperature: ${doc['temperature']}\nResult: ${doc['result']}"),
                  isThreeLine: true,
                  trailing: (doc['imageUrl'] != null)
                      ? Image.network(doc['imageUrl'],
                          width: 40, height: 40, fit: BoxFit.cover)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

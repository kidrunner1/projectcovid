import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/evaluate_symptoms.dart';

class Show_Test extends StatefulWidget {
  const Show_Test({super.key});

  @override
  State<Show_Test> createState() => _Show_TestState();
}

class _Show_TestState extends State<Show_Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("บันทักอาการประจำวัน"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("evaluate_symptoms")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available.'));
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Container(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: FittedBox(
                        child: Text(document["date"]),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the symptom assessment page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Evaluate_Symptoms()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

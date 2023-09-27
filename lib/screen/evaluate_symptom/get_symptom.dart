import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Create a new Dart file for the EditSymptomScreen and import it here

class GetData_EvaluateSymptom extends StatefulWidget {
  final List<DocumentSnapshot<Object?>> symptomData;
  final DateTime selectedDate;

  const GetData_EvaluateSymptom({
    Key? key,
    required this.symptomData,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<GetData_EvaluateSymptom> createState() =>
      _GetData_EvaluateSymptomState();
}

class _GetData_EvaluateSymptomState extends State<GetData_EvaluateSymptom> {
  List<Map<String, dynamic>> symptomData = [];

  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('evaluate_symptoms')
            .where('userID', isEqualTo: user.uid)
            .where('date',
                isEqualTo: DateFormat("yyyy-MM-dd").format(widget.selectedDate))
            .get();

        setState(() {
          symptomData = querySnapshot.docs
              .map((doc) => {
                    ...doc.data() as Map<String, dynamic>,
                    'documentId': doc.id, // Store the document ID
                  })
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(
          'รายละเอียดอาการประจำวัน',
          style: GoogleFonts.prompt(fontSize: 22, color: Colors.white),
        ),
      ),
      body: Center(
        // ignore: unnecessary_null_comparison
        child: symptomData != null && symptomData.isNotEmpty
            ? ListView.builder(
                itemCount: symptomData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> symptoms =
                      symptomData[index]['symptoms'] as Map<String, dynamic>;

                  List<String> selectedSymptoms = [];

                  symptoms.forEach((symptom, value) {
                    if (value == 'Y') {
                      selectedSymptoms.add(symptom);
                    }
                  });
                  selectedSymptoms.sort((a, b) => a.compareTo(b));

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'วันที่ประเมินอาการ : ${symptomData[index]['date']}',
                            style: GoogleFonts.prompt(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'เวลาที่ประเมินอาการ : ${symptomData[index]['time']}',
                            style: GoogleFonts.prompt(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'รายละเอียดอาการ : ',
                            style: GoogleFonts.prompt(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: selectedSymptoms.map((symptom) {
                              return Text(
                                symptom,
                                style: GoogleFonts.prompt(
                                  fontSize: 16,
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          // Edit and Delete Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  //Show a confirmation dialog before deleting the symptom
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'ยืนยันการลบ',
                                        style: GoogleFonts.prompt(
                                            color: Colors.black, fontSize: 22),
                                      ),
                                      // titleTextStyle: GoogleFonts.prompt(
                                      //     fontSize: 20,
                                      //     fontWeight: FontWeight.bold),
                                      content: Text(
                                        'คุณแน่ใจหรือไม่ว่าต้องการลบอาการนี้?',
                                        style: GoogleFonts.prompt(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'ยกเลิก',
                                            style: GoogleFonts.prompt(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // Delete the symptom data from Firestore
                                            await FirebaseFirestore.instance
                                                .collection('evaluate_symptoms')
                                                .doc(symptomData[index]
                                                    ['documentId'])
                                                .delete();

                                            // Remove the symptom from the list
                                            setState(() {
                                              symptomData.removeAt(index);
                                            });

                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'ลบ',
                                            style: GoogleFonts.prompt(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete),
                                label: Text(
                                  'ลบอาการนี้',
                                  style: GoogleFonts.prompt(
                                      color: Colors.white, fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[300]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'No symptom data available',
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }
}

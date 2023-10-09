import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  @override
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
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: Text(
            'รายละเอียดอาการประจำวัน',
            style: GoogleFonts.prompt(fontSize: 22, color: Colors.white),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.red[300],
                      child: const Icon(
                        Icons.health_and_safety_outlined,
                        color: Colors.white,
                        size: 60,
                      )),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายละเอียดของการประเมินอาการ',
                          style: GoogleFonts.prompt(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[300],
                          ),
                        ),
                        Text(
                          'รายการอาการของผู้ใช้',
                          style: GoogleFonts.prompt(
                            fontSize: 16,
                            color: Colors.red[300],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: symptomData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> symptoms =
                        symptomData[index]['symptoms'] as Map<String, dynamic>;
                    List<String> selectedSymptoms = symptoms.keys
                        .where((key) => symptoms[key] == "Y")
                        .toList();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
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
                            ...selectedSymptoms.map((symptom) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  symptom,
                                  style: GoogleFonts.prompt(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                              );
                            }).toList(),
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'ยืนยันการลบ',
                                      style: GoogleFonts.prompt(
                                          color: Colors.black, fontSize: 22),
                                    ),
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
                                          await FirebaseFirestore.instance
                                              .collection('evaluate_symptoms')
                                              .doc(symptomData[index]
                                                  ['documentId'])
                                              .delete();
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
                      ),
                    );
                  },
                ),
              )
            ])));
  }
}

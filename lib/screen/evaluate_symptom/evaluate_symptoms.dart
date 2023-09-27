import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
//import 'package:tracker_covid_v1/feture/news_screen.dart';

import 'package:tracker_covid_v1/screen/evaluate_symptom/showdata_symptom.dart';
import 'package:tracker_covid_v1/screen/main_page.dart';
import '../../model/users.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Evaluate_Symptoms extends StatefulWidget {
  const Evaluate_Symptoms({super.key});

  @override
  State<Evaluate_Symptoms> createState() => _Evaluate_SymptomsState();
}

class _Evaluate_SymptomsState extends State<Evaluate_Symptoms> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;
  Users user = Users(uid: "gg");
  Map<String, String> selectedSymptoms = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUSer();
  }

  final formKey = GlobalKey<FormState>();
  Map<String, String> symptoms = {
    '1. มีไข้ / วัดอุณหภูมิได้ 37.5 C ขึ้นไปหรือไม่': '',
    '2. ไอ มีน้ำมูก เจ็บคอ': '',
    '3. ถ่ายเหลว': '',
    '4. จมูกไม่ได้กลิ่น ลิ้นไม่รับรส': '',
    '5. ตาแดง มีผื่น': '',
    '6. ไม่มีโรคประจำตัวร่วม': '',
    '7. แน่นหน้าอก / หายใจไม่ค่อยสะดวก / หายใจเร็ว หายใจลำบาก ไอแล้วรู้สึกเหนื่อย ':
        '',
    '8. ถ่ายเหลวมากกว่า 3 ครั้ง/วัน': '',
    '9. อ่อนเพลีย เวียนศีรษะ / หน้ามืด วิงเวียน': '',
    '10. หอบเหนื่อย พูดไม่เป็นประโยค/ แน่นหน้าอกตลอดเวลา หายใจแล้วเจ็บหน้าอก':
        '',
    '11. ซึม เรียกไม่รู้สึกตัว ตอบสนองช้า': '',
  };

  bool _isValidForm() {
    for (var value in symptoms.values) {
      if (value == '') {
        return false;
      }
    }
    return true;
  }

  Future<void> sendDataToFirestore() async {
    if (!_isValidForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาตอบคำถามให้ครบทุกข้อ',
              style: GoogleFonts.prompt(fontSize: 23)),
        ),
      );
      return;
    }
    // Create a map to store the selected symptoms
    // Map<String, String> selectedSymptoms = {};
    bool hasCovidSymptoms = false;
    bool hasOtherSymptoms = false;

    for (var entry in symptoms.entries) {
      if (entry.value == 'Y') {
        selectedSymptoms[entry.key] = entry.value;
        if ([
          '1. มีไข้ / วัดอุณหภูมิได้ 37.5 C ขึ้นไปหรือไม่',
          '2. ไอ มีน้ำมูก เจ็บคอ',
          '4. จมูกไม่ได้กลิ่น ลิ้นไม่รับรส'
        ].contains(entry.key)) {
          hasCovidSymptoms = true;
        } else {
          hasOtherSymptoms = true;
        }
      }
    }
    if (hasCovidSymptoms) {
      _showAlert(
        context,
        topicMessage: 'ผลการประเมินอาการ',
        title: 'อาการเบื้องต้นของผู้ติดเชื้อ!',
        content:
            'คำแนะนำจากการทำแบบประเมินอาการ:\n1) แยกห้องพัก ของใช้ส่วนตัวกับผู้อื่น\n(หากแยกไม่ได้ ควรอยู่ให้ห่างจากผู้อื่นมากที่สุด)\n2) ห้ามออกจากที่พักและปฏิเสธผู้ใดมาเยี่ยมที่บ้าน\n3) หลีกเลี่ยงการรับประทานอาหารร่วมกัน\n4) สวมหน้ากากอนามัยตลอดเวลา หากไม่ได้อยู่คนเดียว\n5) เว้นระยะห่าง อย่างน้อย 2 เมตร\n6) แยกซักเสื้อผ้า รวมไปถึงควรใช้ห้องน้ำแยกจากผู้อื่น\n\nคุณต้องการบันทึกอาการโควิดเลยหรือไม่ ? ',
        image: Image.asset("assets/images/icons/warning.png", height: 100),
      );
    } else if (hasOtherSymptoms) {
      // ignore: use_build_context_synchronously
      _showAlert(
        context,
        topicMessage: 'ผลการประเมินอาการ',
        title: 'คุณไม่มีอาการเสี่ยงติดเชื้อโควิด',
        content:
            '   แต่อาจจะเสี่ยงเป็นโรคร้ายแรงอื่นๆ\nคำแนะนำจากการประเมินอาการ : \n ***ถ้าหากมีอาการข้างเคียงที่รุนแรง ***\n       แนะนำให้รีบเข้าพบแพทย์ทันที!! ',
        image: Image.asset("assets/images/icons/warning.png", height: 100),
      );
    } else {
      _showAlert(
        topicMessage: 'ผลการประเมินอาการ',
        context,
        title: 'ยินดีด้วย!! ตอนนี้คุณสุขภาพร่างกายแข็งแรงดี',
        content: null,
        image: Image.asset("assets/images/icons/check.png", height: 100),
      );
    }
    // Check if there are any selected symptoms
    if (selectedSymptoms.isNotEmpty) {
      try {
        DateFormat dateFormat = DateFormat("yyy-MM-dd");
        DateFormat timeFormat = DateFormat("HH:mm:ss");
        DateTime now = DateTime.now();
        await FirebaseFirestore.instance.collection('evaluate_symptoms').add({
          'userID': currentUser?.uid,
          'symptoms': selectedSymptoms,
          'email': user.email,
          'date': dateFormat.format(now), // Separate date field
          'time': timeFormat.format(now), // Separate time field
        });
        // var data;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => GetData_EvaluateSymptom(
        //             symptomData: data,
        //             selectedDate: data,
        //           )),
        // );
      } catch (e) {
        print('Error adding data to Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(child: Text("${snapshot.error}")),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBar(
                backgroundColor: Colors.red[300],
                title: Center(
                  child: Text(
                    'แบบประเมินอาการ',
                    style: GoogleFonts.prompt(fontSize: 25),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.pink[50],
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    ...symptoms.keys.map((String symptom) {
                      return ListTile(
                        title: Text(
                          symptom,
                          style: GoogleFonts.prompt(fontSize: 18),
                        ),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                              value: 'Y',
                              groupValue: symptoms[symptom],
                              onChanged: (value) {
                                setState(() {
                                  symptoms[symptom] = value!;
                                });
                              },
                            ),
                            Text('มี', style: GoogleFonts.prompt(fontSize: 18)),
                            Radio(
                              value: 'N',
                              groupValue: symptoms[symptom],
                              onChanged: (value) {
                                setState(() {
                                  symptoms[symptom] = value!;
                                });
                              },
                            ),
                            Text('ไม่มี',
                                style: GoogleFonts.prompt(fontSize: 18)),
                          ],
                        ),
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: ElevatedButton.icon(
                        onPressed: sendDataToFirestore,
                        label: Text('เช็คอาการ',
                            style: GoogleFonts.prompt(fontSize: 23)),
                        icon: Icon(Icons.check),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.green[300],
                          minimumSize: const Size(250, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }

  void getUSer() async {
    final auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    Users? tempData = await Users.getUser(uid);
    if (tempData != null) {
      setState(() {
        user = tempData;
      });
    }
  }

  void _showAlert(BuildContext context,
      {required String title,
      String? content,
      required,
      required Image image,
      required String topicMessage}) {
    Alert(
      context: context,
      image: image,
      title: "",
      desc: null,
      content: Column(children: [
        Text(
          topicMessage,
          style: GoogleFonts.prompt(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Chip(
          label: Text(
            title,
            style: GoogleFonts.prompt(fontSize: 18, color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        SizedBox(height: 10),
        if (content != null)
          Text(
            content,
            style: GoogleFonts.prompt(fontSize: 16),
          ),
      ]),
      buttons: [
        DialogButton(
          child: Text(
            "ใช่",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            // Close the dialog and navigate to DetailsCheckScreen
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return showdata_symptom();
            }));
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "ไม่",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            // Close the dialog and navigate to NewsScreens
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MyHomePage();
            }));
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tracker_covid_v1/screen/evaluate_symptom/evaluate_symptoms.dart';
import 'package:tracker_covid_v1/screen/evaluate_symptom/get_symptom.dart';

class showdata_symptom extends StatefulWidget {
  const showdata_symptom({super.key});

  @override
  State<showdata_symptom> createState() => _showdata_symptomState();
}

class _showdata_symptomState extends State<showdata_symptom> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // Stream<QuerySnapshot>? _stream;
  bool informationAvailable = false;
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {});
  }

  String _ordinal(int n) {
    if (n == 1) return "1";
    if (n == 2) return "2";
    if (n == 3) return "3";
    return "${n}";
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.home),
          label: 'หน้าหลัก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: 'แชท',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.gear),
          label: 'ตั้งค่า',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.person),
          label: 'ข้อมูลส่วนตัว',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.red[400],
      selectedItemColor: Colors.grey[300],
      unselectedItemColor: Colors.white70,
      unselectedLabelStyle: GoogleFonts.prompt(
        color: Colors.white.withOpacity(0.7),
        fontSize: 12,
      ),
      selectedLabelStyle: GoogleFonts.prompt(
        color: Colors.deepPurple.shade50,
        fontSize: 14,
      ),
    );
  }

  Future<int> getAssessmentCountToday() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('evaluate_symptoms')
          .where('userID', isEqualTo: user.uid)
          .where('date', isEqualTo: DateTime.now().toString().split(' ')[0])
          .get();
      return querySnapshot.size;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(
          'แบบประเมินอาการประจำวัน',
          style: GoogleFonts.prompt(fontSize: 22),
        ),
      ),
      backgroundColor: Colors.pink[50],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("evaluate_symptoms")
            .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("มีบางอย่างผิดพลาด"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'คุณยังไม่เคยประเมินอาการเลยใช่มั้ย?\n   เรามาเริ่มประเมินอาการกันเลย!!',
              style: GoogleFonts.prompt(fontSize: 22, color: Colors.black),
            ));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "กรุณาทำการบันทึก\nผลตรวจประจำวัน",
                style: TextStyle(fontSize: 25),
              ),
            );
          }

          // Group data by date
          Map<String, List<QueryDocumentSnapshot>> groupedData = {};
          for (var doc in docs) {
            final date = doc['date'] as String;
            if (!groupedData.containsKey(date)) {
              groupedData[date] = [];
            }
            groupedData[date]!.add(doc);
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: groupedData.length,
              itemBuilder: (context, index) {
                final date = groupedData.keys.elementAt(index);
                final data = groupedData[date]!;

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    title: Text(
                      'บันทึกวันที่  $date',
                      style: GoogleFonts.prompt(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      final DateTime selectedDate =
                          DateTime.parse(date); // Convert date to DateTime
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GetData_EvaluateSymptom(
                            symptomData: data,
                            selectedDate: selectedDate,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          int assessmentCountToday = await getAssessmentCountToday();
          if (assessmentCountToday >= 3) {
            // ignore: use_build_context_synchronously
            Alert(
              context: context,
              type: AlertType.warning,
              title: "",
              // desc: "",
              content: Column(children: [
                Text(
                  "วันนี้คุณได้ประเมินอาการครบแล้ว",
                  style: GoogleFonts.prompt(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "พรุ่งนี้มาเริ่มประเมินอาการกันใหม่นะ",
                  style: GoogleFonts.prompt(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )
              ]),
              buttons: [
                DialogButton(
                  child: Text(
                    "ตกลง",
                    style:
                        GoogleFonts.prompt(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: Color.fromRGBO(0, 179, 134, 1.0),
                ),
              ],
            ).show();
          } else {
            // Check if the user can assess symptoms
            if (assessmentCountToday < 3) {
              // Navigate to the symptom assessment page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Evaluate_Symptoms()),
              );
            }
          }
        },
        backgroundColor: Colors.red[500],
        child: Icon(Icons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}

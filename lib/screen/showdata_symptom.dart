import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/evaluate_symptoms.dart';

class showdata_symptom extends StatefulWidget {
  const showdata_symptom({super.key});

  @override
  State<showdata_symptom> createState() => _showdata_symptomState();
}

class _showdata_symptomState extends State<showdata_symptom> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  bool informationAvailable = false;
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
          label: 'ตั่่งค่า',
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

          // Display the data as a ListView of ListTiles
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              var dateString = document['date']
                  as String; // Access the 'date' field as a String

              // return ListTile(
              //   title: document.contains('date') // Check if 'date' field exists
              //       ? Text('Date: $dateString')
              //       : Text('Date not available'),
              // );
            },
          );
        },
      ),
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
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}

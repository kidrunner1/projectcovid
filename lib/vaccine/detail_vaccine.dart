import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/model/users.dart';

class ShowDetail_Location extends StatefulWidget {
  const ShowDetail_Location({super.key});

  @override
  State<ShowDetail_Location> createState() => _ShowDetail_LocationState();
}

class _ShowDetail_LocationState extends State<ShowDetail_Location> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User? currentUser = FirebaseAuth.instance.currentUser;
  Users user = Users(uid: "gg");

  String vaccineName = '';
  String vaccineDate = '';
  String vaccineTime = '';
  String vaccineLocation = '';

  String _name = '';
  String _idNumber = '';
  String _phoneNumber = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUSer();
  }

  // Function to handle sending data to Firestore
  void sendDataToFirestore() {
    if (_formKey.currentState!.validate()) {
      print('_name: $_name');
      print('_idNumber: $_idNumber');
      print('_phoneNumber: $_phoneNumber');

      FirebaseFirestore.instance.collection('vaccine_detail').add({
        'userID': currentUser?.uid,
        'username': _name,
        'ID card': _idNumber,
        'telephone number': _phoneNumber,
        'vaccineName': vaccineName,
        'vaccineDate': vaccineDate,
        'vaccineTime': vaccineTime,
        'vaccineLocation': vaccineLocation,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in the information completely.'),
        ),
      );
    }
  }

  // Function to build the header section
  Widget buildHeader() {
    return Column(
      children: [
        Image.asset('assets/images/logo_hospital.png', height: 150),
        SizedBox(height: 10),
        Text("โรงพยาบาลสกลนคร",
            style: GoogleFonts.prompt(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 48, 110, 50),
            )),
        Text("SAKON NAKHON HOSPITAL",
            style: GoogleFonts.prompt(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 48, 110, 50),
            )),
        SizedBox(height: 10),
        // Add other header elements here
      ],
    );
  }

  // Function to build the vaccine details section
  Widget buildVaccineDetails() {
    vaccineName = "Sinavac(เข็มที่ 1) + Sinavac(เข็มที่ 2)";
    vaccineDate = "16 ธันวาคม 2566";
    vaccineTime = "09.00 น. เป็นต้นไป";
    vaccineLocation = "โรงพยาบาลศูนย์สกลนคร";

    return Column(
      children: [
        Text("วัคซีน เข็มที่ 1 (รอบที่ 1)",
            style: GoogleFonts.prompt(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        Text("-----------------------------------",
            style: GoogleFonts.prompt(
              fontSize: 23,
              color: Colors.black,
            )),
        Text("รายละเอียด",
            style: GoogleFonts.prompt(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        SizedBox(height: 5),
        Text("ชื่อวัคซีน : Sinavac(เข็มที่ 1) + Sinavac(เข็มที่ 2)",
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            )),
        Text("วันที่ : 16 ธันวาคม 2566",
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            )),
        Text("เวลา : 09.00 น. เป็นต้นไป",
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            )),
        Text("สถานที่ฉีด : โรงพยาบาลศูนย์สกลนคร",
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            )),
        SizedBox(height: 10),
        Text("***** จำกัดสิทธิ์แค่ 150 คน *****",
            style: GoogleFonts.prompt(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            )),
        SizedBox(height: 10),
        Image.asset('assets/images/vaccine.jpg', height: 150),
        SizedBox(height: 15),
        Text("กรอกข้อมูลเพื่อลงทะเบียน",
            style: GoogleFonts.prompt(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        // Add other vaccine details here
      ],
    );
  }

  // Function to build the registration form
  Widget buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("ชื่อ-สกุล",
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: Colors.black,
                    )),
                hintText: 'ระบุชื่อ-นามสกุล',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกข้อมูล';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("เลขประจำตัวประจำตัวประชาชน",
                      style: GoogleFonts.prompt(
                        fontSize: 16,
                        color: Colors.black,
                      )),
                  hintText: 'ระบุหมายเลขบัตรประชาชน',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณากรอกข้อมูล';
                  }
                  // Check if the entered value contains exactly 13 digits.
                  if (value.length != 13 || int.tryParse(value) == null) {
                    return 'เลขบัตรประชาชนของคุณไม่ถูกต้อง';
                  }
                  // ignore: null_check_always_fails
                  return null;
                },
                onSaved: (value) {
                  _idNumber = value!;
                },
                keyboardType: TextInputType.number),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("เบอร์โทรศัพท์",
                      style: GoogleFonts.prompt(
                        fontSize: 16,
                        color: Colors.black,
                      )),
                  hintText: 'ระบุหมายเลขโทรศัพท์',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณากรอกข้อมูล';
                  }
                  // Check if the entered value is a complete 10-digit phone number starting with '0'
                  // and followed by either 9, 6, or 8 digits.
                  if (!RegExp(r'^0[968][0-9]{8}$').hasMatch(value)) {
                    return 'เบอร์โทรศัพท์ของคุณไม่ถูกต้อง';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
                keyboardType: TextInputType.phone),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: ElevatedButton.icon(
              onPressed: sendDataToFirestore,
              label: Text('ลงทะเบียน', style: GoogleFonts.prompt(fontSize: 23)),
              icon: Icon(Icons.check),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Colors.green[300],
                minimumSize: const Size(250, 50),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(
          'สถานที่ฉีดวัคซีน',
          style: GoogleFonts.prompt(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              buildHeader(),
              buildVaccineDetails(),
              buildRegistrationForm(),
            ],
          ),
        ),
      ),
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
}

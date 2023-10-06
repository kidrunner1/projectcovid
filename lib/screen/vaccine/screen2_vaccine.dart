import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/model/users.dart';
<<<<<<< HEAD:lib/vaccine/detail_vaccine.dart
import 'package:tracker_covid_v1/vaccine/page__vac.dart';
=======
import 'package:tracker_covid_v1/screen/appointment/showdata_appoints.dart';
import 'package:tracker_covid_v1/screen/vaccine/getdata_vaccine.dart';
>>>>>>> origin/pim01:lib/screen/vaccine/screen2_vaccine.dart

class ShowDetail_Location2 extends StatefulWidget {
  const ShowDetail_Location2({super.key});

  @override
  State<ShowDetail_Location2> createState() => _ShowDetail_Location2State();
}

class _ShowDetail_Location2State extends State<ShowDetail_Location2> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _IDcardController = TextEditingController();
  final _PhoneNumberController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  Users user = Users(uid: "gg");

  String vaccineRound = '';
  String vaccineName = '';
  String vaccineDate = '';
  String vaccineTime = '';
  String vaccineLocation = '';

<<<<<<< HEAD:lib/vaccine/detail_vaccine.dart
=======
  bool isRegistered = false; // Track registration status

>>>>>>> origin/pim01:lib/screen/vaccine/screen2_vaccine.dart
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRegistrationStatus(); // Check registration status when the page loads
    getUSer();
  }

  void getRegistrationStatus() async {
    // Check if the current user has already registered
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('vaccine_detail')
        .where('userID', isEqualTo: currentUser?.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        isRegistered = true; // User is registered, disable registration button
      });
    }
  }

  // Function to handle sending data to Firestore
  void sendDataToFirestore() {
    if (_formKey.currentState!.validate()) {
<<<<<<< HEAD:lib/vaccine/detail_vaccine.dart
      // Retrieve values from TextEditingController
=======
>>>>>>> origin/pim01:lib/screen/vaccine/screen2_vaccine.dart
      String name = _firstNameController.text;
      String idNumber = _IDcardController.text;
      String phoneNumber = _PhoneNumberController.text;

<<<<<<< HEAD:lib/vaccine/detail_vaccine.dart
      UserData userData = UserData(
        name: name,
        idCard: idNumber,
        phoneNumber: phoneNumber,
      );

      // Your Firestore code here to add the data
      FirebaseFirestore.instance.collection('vaccine_detail').add({
        'userID': currentUser?.uid,
        'username': name,
        'ID card': idNumber,
        'telephone number': phoneNumber,
        'vaccineName': vaccineName,
        'vaccineDate': vaccineDate,
        'vaccineTime': vaccineTime,
        'vaccineLocation': vaccineLocation,
      }).then((_) {
        // Navigate to Vaccine_page and pass the user data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Vaccine_page(userData: userData),
          ),
=======
      if (isRegistered) {
        // User is already registered, show a message or take appropriate action
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ลงทะเบียนรับวัคซีน'),
              content: Text(
                  'คุณได้ลงทะเบียนเรียบร้อยแล้ว ไม่สามารถลงทะเบียนซ้ำได้อีก'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Showdata_appoints(), // Replace 'YourAppointmentPage' with your actual appointment page
                      ),
                    );
                  },
                ),
              ],
            );
          },
>>>>>>> origin/pim01:lib/screen/vaccine/screen2_vaccine.dart
        );
      } else {
        // Your Firestore code here to add the data
        FirebaseFirestore.instance.collection('vaccine_detail').add({
          'userID': currentUser?.uid,
          'username': name,
          'ID card': idNumber,
          'telephone number': phoneNumber,
          'vaccineRound': vaccineRound,
          'vaccineName': vaccineName,
          'vaccineDate': vaccineDate,
          'vaccineTime': vaccineTime,
          'vaccineLocation': vaccineLocation,
        }).then((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  // Custom shape
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5.0, // Elevation for a shadow effect
                title: Text(
                  'ลงทะเบียนรับวัคซีน',
                  style: GoogleFonts.prompt(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                content: Text(
                  'คุณได้ทำการลงทะเบียนรับวัคซีนเรียบร้อย',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'แสดงรายละเอียด',
                      style: GoogleFonts.prompt(
                          color: Color.fromARGB(255, 48, 110,
                              50) // Give some color to your action text
                          ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GetData_Vaccine(
                            getappoints: {},
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .red // Background color for the primary button
                        ),
                    child: Text(
                      'ปิด',
                      style: GoogleFonts.prompt(
                        color:
                            Colors.white, // Give some color to your action text
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Showdata_appoints(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
            ),
          );
        });
      }
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
    vaccineRound = "วัคซีน เข็มที่ 1 (รอบที่ 2)";
    vaccineName = "Sinavac(เข็มที่ 1) + AstraZeneca(เข็มที่ 2)";
    vaccineDate = "20 มกราคม 2567";
    vaccineTime = "09.00 น. เป็นต้นไป";
    vaccineLocation = "โรงพยาบาลศูนย์สกลนคร";

    return Column(
      children: [
        Text("วัคซีน รอบที่ 2",
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
        Text("Sinavac(เข็มที่ 1) + AstraZeneca(เข็มที่ 2)",
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            )),
        Text("20 มกราคม 2567",
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
              controller: _firstNameController,
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
                _firstNameController.text = value!;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
                controller: _IDcardController,
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
                  _IDcardController.text = value!;
                },
                keyboardType: TextInputType.number),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
                controller: _PhoneNumberController,
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

                  if (!RegExp(r'^0[968][0-9]{8}$').hasMatch(value)) {
                    return 'เบอร์โทรศัพท์ของคุณไม่ถูกต้อง';
                  }
                  return null;
                },
                onSaved: (value) {
                  _PhoneNumberController.text = value!;
                },
                keyboardType: TextInputType.phone),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                sendDataToFirestore();
              },
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
          'ลงทะเบียนรับวัคซีนโควิด-19',
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

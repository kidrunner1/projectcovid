import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tracker_covid_v1/model/users.dart';
import 'package:tracker_covid_v1/screen/appointment/showdata_appoints.dart';
import 'package:tracker_covid_v1/screen/vaccine/getdata_vaccine.dart';
import 'package:tracker_covid_v1/screen/vaccine/show_vaccine.dart';

class ShowDetail_Location extends StatefulWidget {
  const ShowDetail_Location({super.key});

  @override
  State<ShowDetail_Location> createState() => _ShowDetail_LocationState();
}

class _ShowDetail_LocationState extends State<ShowDetail_Location> {
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

  bool isRegistered = false; // Track registration status

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

  Future<void> getUSer() async {
    final auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    Users? tempData = await Users.getUser(uid);
    if (tempData != null) {
      setState(() {
        user = tempData;
      });
    }
  }

  void showRegistrationDialog(
      {required BuildContext dialogContext,
      required Map<String, dynamic> data}) {
    Alert(
      context: dialogContext,
      type: AlertType.success,
      title: "ลงทะเบียนรับวัคซีน",
      desc: "คุณได้ทำการลงทะเบียนรับวัคซีนเรียบร้อย",
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        titleStyle: GoogleFonts.prompt(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        descStyle: GoogleFonts.prompt(fontSize: 18),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "รายละเอียด",
            style: GoogleFonts.prompt(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(dialogContext);
            Navigator.pushReplacement(
              dialogContext,
              MaterialPageRoute(
                builder: (context) => GetData_Vaccine(
                  getappoints: data,
                ),
              ),
            );
          },
          color: Colors.green,
        ),
        DialogButton(
          child: Text(
            "ปิด",
            style: GoogleFonts.prompt(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(dialogContext);
            // Add the navigation to "โชววัคซีน" page here
            Navigator.pushReplacement(
              dialogContext,
              MaterialPageRoute(
                builder: (context) =>
                    ShowData_VaccineLocation(), // Replace with the actual widget for the "โชววัคซีน" page
              ),
            );
          },
          color: Colors.red,
        ),
      ],
    ).show();
  }

  Future<DocumentReference?> sendDataToFirestore() async {
    if (_formKey.currentState!.validate()) {
      String name = _firstNameController.text;
      String idNumber = _IDcardController.text;
      String phoneNumber = _PhoneNumberController.text;

      if (isRegistered) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ลงทะเบียนรับวัคซีน'),
              content: const Text(
                  'คุณได้ลงทะเบียนเรียบร้อยแล้ว ไม่สามารถลงทะเบียนซ้ำได้อีก'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
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
        return null;
      } else {
        try {
          DocumentReference docRef = FirebaseFirestore.instance
              .collection('vaccine_detail')
              .doc(); // Get a new document reference with an auto-generated ID

          await docRef.set({
            'id': docRef.id, // use the ID of the document reference
            'userID': currentUser?.uid,
            'username': name,
            'ID card': idNumber,
            'telephone number': phoneNumber,
            'vaccineRound': vaccineRound,
            'vaccineName': vaccineName,
            'vaccineDate': vaccineDate,
            'vaccineTime': vaccineTime,
            'vaccineLocation': vaccineLocation,
          });

          DocumentSnapshot docSnapshot = await docRef.get();

          if (docSnapshot.exists) {
            Map<String, dynamic>? docData =
                docSnapshot.data() as Map<String, dynamic>?;
            if (docData != null) {
              showRegistrationDialog(dialogContext: context, data: docData);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Document is empty.'),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Document not found.'),
              ),
            );
          }

          return docRef;
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
            ),
          );
          return null;
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in the information completely.'),
        ),
      );
      return null;
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
    vaccineRound = "วัคซีน รอบที่ 1";
    vaccineName = "Sinavac(เข็มที่ 1) + Sinavac(เข็มที่ 2)";
    vaccineDate = "16 ธันวาคม 2566";
    vaccineTime = "09.00 น. เป็นต้นไป";
    vaccineLocation = "โรงพยาบาลศูนย์สกลนคร";

    return Column(
      children: [
        Text("วัคซีน รอบที่ 1",
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
        Text("***** จำกัดสิทธิ์แค่ 120 คน *****",
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
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracker_covid_v1/screen/appointment/getdata_appoints.dart';
import 'package:tracker_covid_v1/screen/main_page.dart';
import '../../database/appoints_db.dart';

class FormAppointments extends StatefulWidget {
  const FormAppointments({super.key});
  @override
  State<FormAppointments> createState() => _FormAppointmentsState();
}

class _FormAppointmentsState extends State<FormAppointments> {
  String selectedTime = '';
  final dateController = TextEditingController();
  final fristnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final hospitalNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late Appoints_DB appointmentService;

  void navigateToShowDetails(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GetdataAppoints(getappoints: data),
      ),
    );
  }

  void resetFormMethod() {
    dateController.clear();
    fristnameController.clear();
    lastnameController.clear();
    hospitalNameController.clear();
    setState(() {
      selectedTime = '';
    });
  }

  @override
  void initState() {
    super.initState();
    appointmentService = Appoints_DB(
      context,
      navigateToShowDetails,
      resetFormMethod,
      firestore: FirebaseFirestore.instance,
    );
    _fetchUserDetails();
  }

  _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle this situation, perhaps show an error or navigate to login page
      print("No user is signed in.");
      return;
    }

    if (user.displayName != null && user.displayName!.contains(' ')) {
      setState(() {
        fristnameController.text = user.displayName?.split(' ').first ?? '';
        lastnameController.text = user.displayName?.split(' ').last ?? '';
      });
    } else {
      // Handle situation where the display name is not in expected format
      // Maybe set a default value or prompt user to provide name
      print("User's display name is not in the expected format.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ติดต่อเข้ารับยา",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.red[300],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: hospitalNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: ("Hospital Name"),
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(width: 3),
                    ),
                  ),
                  validator: RequiredValidator(
                      errorText: "Please enter the hospital name"),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                    labelText: ("วัน/เดือน/ปี"),
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(width: 3),
                    ),
                  ),
                  validator:
                      RequiredValidator(errorText: "กรุณาระบุวัน/เดือน/ปี"),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      locale: const Locale("th", "TH"),
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      int yearInBE = pickedDate.year + 543;
                      String formattedDate =
                          DateFormat('d MMMM', 'th_TH').format(pickedDate) +
                              ' $yearInBE';
                      dateController.text = formattedDate;
                    } else {
                      print("Date is not selected");
                    }
                  },
                ),
              ),
              const SizedBox(height: 35),
              const Text(
                'ช่วงเวลาเข้ารับยา',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            activeColor: Colors.purple,
                            title: Text('09.00 น.'),
                            value: '09.00 น.',
                            groupValue: selectedTime,
                            onChanged: (val) {
                              setState(() {
                                selectedTime = val!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            activeColor: Colors.purple,
                            title: Text('10.00 น.'),
                            value: '10.00 น.',
                            groupValue: selectedTime,
                            onChanged: (val) {
                              setState(() {
                                selectedTime = val!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RadioListTile(
                            activeColor: Colors.purple,
                            title: Text('11.00 น.'),
                            value: '11.00 น.',
                            groupValue: selectedTime,
                            onChanged: (val) {
                              setState(() {
                                selectedTime = val!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            activeColor: Colors.purple,
                            title: Text('13.00 น.'),
                            value: '13.00 น.',
                            groupValue: selectedTime,
                            onChanged: (val) {
                              setState(() {
                                selectedTime = val!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              const Text(
                'รายละเอียดผู้นัดรับ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: fristnameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: ("ชื่อ"),
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(width: 3),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "กรุณาใส่ชื่อ" : null,
                  enabled:
                      false, // Disables the field so the user cannot modify it
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: lastnameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: ("สกุล"),
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(width: 3),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "กรุณาใส่สกุล" : null,
                  enabled:
                      false, // Disables the field so the user cannot modify it
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedButton(
                      text: 'บันทึก',
                      color: Colors.green,
                      pressEvent: () async {
                        if (formKey.currentState!.validate()) {
                          if (selectedTime.isEmpty) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              title: 'กรอกข้อมูลไม่ครบ',
                              desc: 'กรุณาเลือกช่วงเวลาเข้ารับยา',
                              btnOkOnPress: () {},
                            ).show();
                          } else {
                            await appointmentService.saveToFirebaseAndShowPopup(
                              date: dateController.text,
                              time: selectedTime,
                              firstName: fristnameController.text,
                              lastName: lastnameController.text,
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    AnimatedButton(
                      text: 'ยกเลิก',
                      color: Colors.red,
                      pressEvent: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

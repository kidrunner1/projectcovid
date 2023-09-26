

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:tracker_covid_v1/feture/news_screen.dart';
import 'package:tracker_covid_v1/screen/appointment/getdata_appoints.dart';
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
    setState(() {
      selectedTime = '';
    });
  }

  @override
  void initState() {
    dateController.text = ""; // set the initial value of text field
    super.initState();
    appointmentService = Appoints_DB(
      context,
      navigateToShowDetails,
      resetFormMethod,
      firestore: FirebaseFirestore.instance, // Pass the Firestore instance.
    );
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
        backgroundColor: const Color.fromARGB(255, 239, 154, 154),
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
                  validator: RequiredValidator(errorText: "กรุณาระบุวัน/เดือน/ปี"),
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
                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
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
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
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
                            title: Text('12.00น.'),
                            value: '12.00น.',
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
                            title: Text('13.00น.'),
                            value: '13.00น.',
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
                            title: Text('14.00น.'),
                            value: '14.00น.',
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
                            title: Text('15.00น.'),
                            value: '15.00น.',
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
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
                  validator: RequiredValidator(errorText: "กรุณาใส่ชื่อ"),
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
                  validator: RequiredValidator(errorText: "กรุณาใส่ชื่อ"),
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
                            builder: (context) => NewsScreens(),
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

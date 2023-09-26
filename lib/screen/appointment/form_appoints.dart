import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker_covid_v1/feture/news_screen.dart';
//import 'package:tracker_covid_v1/screen/startscreen.dart';

import '../../database/appoints_db.dart';

class FormAppointments extends StatefulWidget {
  const FormAppointments({super.key});

  @override
  State<FormAppointments> createState() => _FormAppointments();
}

class _FormAppointments extends State<FormAppointments> {
  String selectedTime = '';
  final dateController = TextEditingController();
  final fristnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  late AppointmentService appointmentService;

  @override
  void initState() {
    dateController.text = ""; // set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appointmentService = AppointmentService(context);
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
              // crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller:
                        dateController, //editing controller of this TextField
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      labelText: ("วัน/เดือน/ปี"),
                      labelStyle:
                          TextStyle(color: Colors.black.withOpacity(0.8)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(width: 3)),
                    ),
                    validator:
                        RequiredValidator(errorText: "กรุณาระบุวัน/เดือน/ปี"),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          locale: const Locale("th", "TH"),
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        dateController.text =
                            formattedDate; //set output date to TextField value.
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
                const SizedBox(height: 35),
                const Text('ช่วงเวลาเข้ารับยา',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
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
                      labelStyle:
                          TextStyle(color: Colors.black.withOpacity(0.8)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(width: 3)),
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
                      labelStyle:
                          TextStyle(color: Colors.black.withOpacity(0.8)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(width: 3)),
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
                                  await appointmentService
                                      .saveToFirebaseAndShowPopup(
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
                                      builder: (context) => NewsScreens(
                                            symptomData: null,
                                            selectedDate: null,
                                          )));
                            },
                          ),
                        ]))
              ]),
        )));
  }
}

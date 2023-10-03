import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:tracker_covid_v1/feture/news_screen.dart';
import 'package:tracker_covid_v1/screen/appointment/getappoints.dart';
import '../../database/appoints_db.dart';

class FormAppointments extends StatefulWidget {
  const FormAppointments({super.key});
  @override
  State<FormAppointments> createState() => _FormAppointmentsState();
}

class _FormAppointmentsState extends State<FormAppointments> {
  String selectedTime = '';
  final dateController = TextEditingController();
  final  hospital = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late Appoints_DB appointmentService;
  
    List<String> appointmentTimes = [
    for (int hour = 8; hour <= 17; hour++) 
      if (hour != 12) // Exclude 12.00 to 13.00
        '$hour.00 น. - ${hour+1}.00 น.'
  ];


  void navigateToShowDetails(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GetAppoints(),
      ),
    );
  }

  void resetFormMethod() {
    dateController.clear();
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
                      firstDate: DateTime.now(),
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
                DropdownButton<String>(
                value: selectedTime.isEmpty ? null : selectedTime,
                hint: Text("เลือกช่วงเวลา"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTime = newValue!;
                  });
                },
                items: appointmentTimes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 35),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: hospital,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    helperText:'ใส่ชื่อโรงพยาบาล',
                    labelStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(width: 3),
                    ),
                  ),
                  validator: RequiredValidator(errorText: "กรุณาใส่ชื่อโรงพยาบาล"),
                ),
              ),
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
                              hospital: hospital.text,
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

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker_covid_v1/model/hospital.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/appointment/getdata_appoints.dart';

import 'package:tracker_covid_v1/screen/main_page.dart';
import '../../database/appoints_db.dart';

class FormAppointments extends StatefulWidget {
  const FormAppointments({super.key});
  @override
  State<FormAppointments> createState() => _FormAppointmentsState();
}

class _FormAppointmentsState extends State<FormAppointments>
    with TickerProviderStateMixin {
  String selectedTime = '';
  final dateController = TextEditingController();
  final hospital = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late Appoints_DB appointmentService;
  String? selectedHospital;
  String? userName;
  String? phoneNumber;
  List<String> filteredHospitals = sakonNakhonHospitals;
  List<String> appointmentTimes = [
    for (int hour = 8; hour <= 17; hour++)
      if (hour != 12) // Exclude 12.00 to 13.00
        '$hour.00 น. - ${hour + 1}.00 น.'
  ];
  late AnimationController _animationController;

  void navigateToShowDetails(Map<String, dynamic> data) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GetdataAppoints(getappoints: data),
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
    super.initState();
    dateController.text = "";
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animationController.forward();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((doc) {
        setState(() {
          userName = doc.data()?['name'];
          phoneNumber = doc.data()?['phoneNumber'];
        });
      });
    }

    appointmentService = Appoints_DB(
      context,
      navigateToShowDetails,
      resetFormMethod,
      firestore: FirebaseFirestore.instance,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeData,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          elevation: 4.0,
          title: Text(
            "ติดต่อเข้ารับยา",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.red[300],
        ),
        body: FadeTransition(
          opacity: _animationController,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildIcon(),
                          buildDateTimeField(),
                          const SizedBox(height: 35),
                          buildDropdownMenu(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: buildHospitalField(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/hospital.json',
              width: 200, height: 200)
        ],
      ),
    );
  }

  Widget buildDateTimeField() {
    return TextFormField(
      controller: dateController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.calendar_today,
          color: Colors.blueGrey[700],
        ),
        labelText: ("วัน/เดือน/ปี"),
        labelStyle: GoogleFonts.prompt(color: Colors.blueGrey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: RequiredValidator(errorText: "กรุณาระบุวัน/เดือน/ปี"),
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
              DateFormat('d MMMM', 'th_TH').format(pickedDate) + ' $yearInBE';
          dateController.text = formattedDate;
        } else {
          print("Date is not selected");
        }
      },
    );
  }

  Widget buildDropdownMenu() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "เลือกช่วงเวลา",
        labelStyle: GoogleFonts.prompt(color: Colors.blueGrey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      value: selectedTime.isEmpty ? null : selectedTime,
      onChanged: (String? newValue) {
        setState(() {
          selectedTime = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาเลือกช่วงเวลา';
        }
        return null;
      },
      items: appointmentTimes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.prompt()),
        );
      }).toList(),
    );
  }

  Widget buildHospitalField() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedHospital,
      hint: Text("เลือกโรงพยาบาลใกล้คุณ ",
          style: GoogleFonts.prompt(fontSize: 15)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "เลือกโรงพยาบาล",
        labelStyle:
            GoogleFonts.prompt(color: Colors.blueGrey[700], fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedHospital = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาเลือกโรงพยาบาล';
        }
        return null;
      },
      items: sakonNakhonHospitals.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.prompt()),
        );
      }).toList(),
    );
  }

  Widget buildButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (userName != null && phoneNumber != null)
          Column(
            children: [
              Text('Logged in as: $userName',
                  style: GoogleFonts.prompt(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Phone: $phoneNumber',
                  style: GoogleFonts.prompt(fontSize: 16)),
              SizedBox(height: 20), // spacing
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // center the row
          children: [
            ElevatedButton(
              onPressed: () async {
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
                      hospital: selectedHospital!,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green[700],
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: GoogleFonts.prompt(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text("บันทึก"),
            ),
            const SizedBox(width: 15), // horizontal spacing
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red[700],
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: GoogleFonts.prompt(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text("ยกเลิก"),
            ),
          ],
        ),
      ],
    );
  }
}

final ThemeData _themeData = ThemeData(
  primaryColor: Colors.blueGrey[700],
  hintColor: Colors.cyan[400],
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.cyan[400],
    textTheme: ButtonTextTheme.primary,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.cyan[400]!, width: 2.0),
      borderRadius: BorderRadius.circular(12.0),
    ),
    labelStyle: GoogleFonts.prompt(color: Colors.blueGrey[700]),
  ),
  textTheme: GoogleFonts.promptTextTheme(),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.cyan[400],
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),
);

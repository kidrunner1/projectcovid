import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
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

class _FormAppointmentsState extends State<FormAppointments> {
  String selectedTime = '';
  final dateController = TextEditingController();
  final hospital = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late Appoints_DB appointmentService;
  String? selectedHospital;
  List<String> filteredHospitals = sakonNakhonHospitals;

  List<String> appointmentTimes = [
    for (int hour = 8; hour <= 17; hour++)
      if (hour != 12) // Exclude 12.00 to 13.00
        '$hour.00 น. - ${hour + 1}.00 น.'
  ];

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
    appointmentService = Appoints_DB(
      context,
      navigateToShowDetails,
      resetFormMethod,
      firestore: FirebaseFirestore.instance,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "ติดต่อเข้ารับยา",
          style: GoogleFonts.prompt(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red[300],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) => Column(
              children: [
                buildDateTimeField(),
                const SizedBox(height: 35),
                buildDropdownMenu(),
                const SizedBox(height: 35),
                buildHospitalField(),
                const SizedBox(height: 50),
                buildButtons(),
              ],
            ),
          ),
        ),
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
      items: appointmentTimes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.prompt()),
        );
      }).toList(),
    );
  }

  Widget buildHospitalField() {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            setState(() {
              filteredHospitals = sakonNakhonHospitals
                  .where((hospital) => hospital.contains(value))
                  .toList();
              if (!filteredHospitals.contains(selectedHospital)) {
                // If selected hospital doesn't exist in filtered list, reset it
                selectedHospital = null;
              }
            });
          },
        ),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width -
              40, // Assuming 20 padding on each side,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedHospital,
            hint: Text("เลือกโรงพยาบาลใกล้คุณ ",
                style: GoogleFonts.prompt(
                    fontSize: 15)), // This will show when no item is selected
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
                hospital.text = selectedHospital!;
              });
            },
            items:
                filteredHospitals.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: GoogleFonts.prompt()),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  hospital: hospital.text,
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text("บันทึก", style: GoogleFonts.prompt(color: Colors.white)),
        ),
        SizedBox(height: 15), // Add some space between the buttons.
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
            primary: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text("ยกเลิก", style: GoogleFonts.prompt(color: Colors.white)),
        ),
      ],
    );
  }
}

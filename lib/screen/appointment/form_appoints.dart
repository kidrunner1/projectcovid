import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/feture/news_screen.dart';
import 'package:tracker_covid_v1/screen/main_page.dart';

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
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ติดต่อเข้ารับยา",
          style: GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Date Picker
              TextFormField(
                controller: dateController,
                style: GoogleFonts.prompt(fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon:
                      const Icon(Icons.calendar_today, color: Colors.black),
                  labelText: ("วัน/เดือน/ปี"),
                  labelStyle:
                      GoogleFonts.prompt(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0)),
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
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    dateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 35),
              // Time Picker
              Text('ช่วงเวลาเข้ารับยา',
                  style: GoogleFonts.prompt(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          activeColor: Colors.purple,
                          title: Text('12.00น.',
                              style: GoogleFonts.prompt(fontSize: 16)),
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
                          title: Text('13.00น.',
                              style: GoogleFonts.prompt(fontSize: 16)),
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
                    children: [
                      Expanded(
                        child: RadioListTile(
                          activeColor: Colors.purple,
                          title: Text('14.00น.',
                              style: GoogleFonts.prompt(fontSize: 16)),
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
                          title: Text('15.00น.',
                              style: GoogleFonts.prompt(fontSize: 16)),
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
              const SizedBox(height: 35),
              // Personal Details
              Text('รายละเอียดผู้นัดรับ',
                  style: GoogleFonts.prompt(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: fristnameController,
                style: GoogleFonts.prompt(fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "ชื่อ",
                  labelStyle:
                      GoogleFonts.prompt(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                ),
                validator: RequiredValidator(errorText: "กรุณาระบุชื่อ"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: lastnameController,
                style: GoogleFonts.prompt(fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "สกุล",
                  labelStyle:
                      GoogleFonts.prompt(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                ),
                validator: RequiredValidator(errorText: "กรุณาระบุสกุล"),
              ),
              const SizedBox(height: 40),
              // Save Button
              AnimatedButton(
                text: 'บันทึก',
                pressEvent: () async {
                  if (formKey.currentState!.validate() && selectedTime != '') {
                    await appointments.add({
                      'date': dateController.text,
                      'time': selectedTime,
                      'firstName': fristnameController.text,
                      'lastName': lastnameController.text,
                    }).then((value) {
                      // ignore: avoid_single_cascade_in_expression_statements
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.TOPSLIDE,
                        title: 'สำเร็จ',
                        desc: 'บันทึกข้อมูลเรียบร้อย',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()),
                          );
                        },
                      )..show();
                    }).catchError((error) {
                      // ignore: avoid_single_cascade_in_expression_statements
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.TOPSLIDE,
                        title: 'ผิดพลาด',
                        desc: 'บันทึกข้อมูลไม่สำเร็จ',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      )..show();
                    });
                  }
                },
                gradientColors: [Colors.green, Colors.greenAccent],
              ),
              const SizedBox(height: 10),
              // Cancel Button
              AnimatedButton(
                text: 'ยกเลิก',
                pressEvent: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
                gradientColors: [Colors.red, Colors.redAccent],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback pressEvent;
  final List<Color> gradientColors;

  AnimatedButton({
    required this.text,
    required this.pressEvent,
    this.gradientColors = const [Colors.blue, Colors.blueAccent],
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details),
      onTapUp: (details) => _onTapUp(details),
      onTap: widget.pressEvent,
      child: Transform.scale(
        scale: scale,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.last.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.prompt(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => scale = 1);
  }
}

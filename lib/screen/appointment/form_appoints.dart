import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
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

@override
  void initState() {
    dateController.text = ""; // set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red[100],
        appBar: AppBar(
          title: const Text(
            "ติดต่อเข้ารับยา",
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: const Color.fromARGB(255, 239, 154, 154),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.all(16),
            color: const Color.fromARGB(255, 255, 182, 190),
            child: Column(children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller:
                      dateController, //editing controller of this TextField
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ), //icon of text field
                    labelText: ("วัน/เดือน/ปี"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 120, 119, 119)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 120, 119, 119)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.all(14),
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
              const Text('ช่วงเวลาเข้ารับยา',
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Color.fromARGB(255, 235, 128, 141),
                      fontWeight: FontWeight.bold)),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[
                  RadioListTile(
                    title: Text('12.00น.'),
                    value: '12.00น.',
                    groupValue: selectedTime,
                    onChanged: (val) {
                      setState(() {
                        selectedTime = val!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('13.00น.'),
                    value: '13.00น.',
                    groupValue: selectedTime,
                    onChanged: (val) {
                    setState(() {
                        selectedTime = val!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('14.00น.'),
                    value: '14.00น.',
                    groupValue: selectedTime,
                    onChanged: (val) {
                     setState(() {
                        selectedTime = val!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('15.00น.'),
                    value: '15.00น.',
                    groupValue: selectedTime,
                    onChanged: (val) {
                     setState(() {
                        selectedTime = val!;
                      });
                    },
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              const Text(
                'รายละเอียดผู้นัดรับ',
                style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Color.fromARGB(255, 235, 128, 141),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                height: 50,
                child: TextFormField(
                  controller: fristnameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "ชื่อ",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  validator: RequiredValidator(errorText: "กรุณาใส่ชื่อ"),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                height: 50,
                child: TextFormField(
                  controller: lastnameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "สกุล",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
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
                          pressEvent: () {
                            if (formKey.currentState!.validate()) {
                              if (selectedTime.isEmpty) {
                                // กรณีผลตรวจไม่ถูกเลือก
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  title: 'กรอกข้อมูลไม่ครบ',
                                  desc: 'กรุณาเลือกช่วงเวลาเข้ารับยา',
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                // กรอกข้อมูลสำเร็จ
                                AwesomeDialog(
                                 
                                    context: context,
                                    dialogType: DialogType.success,
                                    title: 'บันทึกข้อมูลเรียบร้อย!!',
                                    desc: '   ',
                                    btnOkOnPress: () {
                                      // if (formKey.currentState!.validate()) {
                                      //   var frist = fristnameController.text;
                                      //   var last = lastnameController.text;
                                      //   var date = dateController.text;
                                      //   var time = selectedTime;
                                      //   Appointments statement = Appointments(
                                      //     fristname: frist,
                                      //     lastname: last,
                                      //     date: date,
                                      //     selectedTime: time,
                                      //   );
                                        

                                      //   var provider =
                                      //       Provider.of<AppointmentsProvider>(
                                      //           context,
                                      //           listen: false);
                                      //   provider.addAppointments(statement);
                                        
                                      //   Navigator.pop(context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) {
                                      //     return const HomeScreen();
                                          
                                      //   }
                                      //   ),
                                      //   );
                                      // }
                                    }).show();
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        AnimatedButton(
                          text: 'ยกเลิก',
                          color: Colors.red,
                          pressEvent: () {},
                        ),
                      ]))
            ]),
          ),
        )));
  }
}

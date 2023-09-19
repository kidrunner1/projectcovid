import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tracker_covid_v1/model/check.dart';
import 'package:tracker_covid_v1/provider/provider_check.dart';
import 'package:tracker_covid_v1/screen/check_covid/form_check.dart';

class EditCheck extends StatefulWidget {
  final String initialDate;
  final String initialTime;
  final String initialWeight;
  final String initialTemp;
  final String initialType;

  EditCheck(
      {required this.initialDate,
      required this.initialTime,
      required this.initialWeight,
      required this.initialTemp,
      required this.initialType});

  @override
  _EditCheckState createState() => _EditCheckState();
}

class _EditCheckState extends State<EditCheck> {
  final TextEditingController dateinput = TextEditingController();
  final TextEditingController timeinput = TextEditingController();
  final TextEditingController weightinput = TextEditingController();
  final TextEditingController tempinput = TextEditingController();
  final checkKey = GlobalKey<FormState>();
  String typeinput = '';

  // get check => null;

  @override
  void initState() {
    super.initState();
    dateinput.text = widget.initialDate;
    timeinput.text = widget.initialTime;
    weightinput.text = widget.initialWeight;
    tempinput.text = widget.initialTemp;
    typeinput = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลนัดรับยา'),
        backgroundColor: const Color.fromARGB(255, 239, 154, 154),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: checkKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[50],
                  ),
                  child: Center(
                    child: TextFormField(
                      controller:
                          dateinput, //editing controller of this TextField
                      decoration: const InputDecoration(
                        suffixIcon:
                            Icon(Icons.calendar_today), //icon of text field
                        labelText: "วัน/เดือน/ปี",
                        contentPadding: EdgeInsets.all(8.0),
                        border: InputBorder.none,
                        //label text of field
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

                          setState(() {
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[50],
                  ),
                  child: Center(
                      child: TextFormField(
                    controller:
                        timeinput, //editing controller of this TextField
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.timer), //icon of text field
                      labelText: "เวลาที่บันทึก",
                      contentPadding: EdgeInsets.all(8.0),
                      border: InputBorder.none, //label text of field
                    ),
                    validator: RequiredValidator(errorText: "กรุณาระบุเวลา"),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        print(pickedTime.format(context)); //output 10:51 PM
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime =
                            DateFormat('HH:mm').format(parsedTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.

                        setState(() {
                          timeinput.text =
                              formattedTime; //set the value of text field.
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                  ))),
              const SizedBox(
                height: 10,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[50],
                  ),
                  child: TextFormField(
                    controller: weightinput,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.scale),
                      labelText: "น้ำหนักปัจจุบัน",
                      contentPadding: EdgeInsets.all(8.0),
                      border: InputBorder.none,
                    ),
                    validator: RequiredValidator(errorText: "กรุณาป้อนน้ำหนัก"),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[50],
                  ),
                  child: TextFormField(
                    controller: tempinput,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.thermostat),
                      labelText: "อุณหภูมิร่างกาย",
                      contentPadding: EdgeInsets.all(8.0),
                      border: InputBorder.none,
                    ),
                    validator:
                        RequiredValidator(errorText: "กรุณาป้อนอุณหภูมิ"),
                  )),
              const SizedBox(height: 10),
              const Text(
                "ผลตรวจ ATK วันนี้",
                style: TextStyle(color: Colors.redAccent, fontSize: 20),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                          contentPadding: const EdgeInsets.all(0.0),
                          value: 'Positive',
                          groupValue: typeinput,
                          activeColor: Colors.red[400],
                          title: const Text('ผลเป็นบวก'),
                          onChanged: (val) {
                            setState(() {
                              typeinput = val!;
                            });
                          }),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                          contentPadding: const EdgeInsets.all(0.0),
                          value: 'Negative',
                          groupValue: typeinput,
                          activeColor: Colors.red[400],
                          title: const Text('ผลเป็นลบ'),
                          onChanged: (val) {
                            setState(() {
                              typeinput = val!;
                            });
                          }),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.normal),
                ),
                onPressed: () {
                  if (checkKey.currentState!.validate()) {
                    if (widget.initialDate != null) {
                      // ถ้ามีข้อมูลเริ่มต้น ให้แก้ไขข้อมูล
                      final editedCheck = CheckModel(
                        date: dateinput.text,
                        time: timeinput.text,
                        weight: weightinput.text,
                        temp: tempinput.text,
                        type: typeinput,
                      );

                      // เรียกใช้งาน Provider และเรียกฟังก์ชัน editCheck
                      final checkProvider =
                          Provider.of<CheckProvider>(context, listen: false);
                      checkProvider.editCheckModel(editedCheck);

                      Navigator.pop(context); // ปิดหน้า EditCheck
                    } else {
                      // ถ้าไม่มีข้อมูลเริ่มต้น ให้บันทึกข้อมูล
                      final newCheck = CheckModel(
                        date: dateinput.text,
                        time: timeinput.text,
                        weight: weightinput.text,
                        temp: tempinput.text,
                        type: typeinput,
                      );

                      // เรียกใช้งาน Provider และเรียกฟังก์ชัน addCheck
                      final checkProvider =
                          Provider.of<CheckProvider>(context, listen: false);
                      checkProvider.addCheckModel(newCheck);

                      Navigator.pop(context); // ปิดหน้า EditCheck
                    }
                  }
                },
                child: Text(
                    widget.initialDate != null ? 'บันทึกข้อมูล' : 'บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

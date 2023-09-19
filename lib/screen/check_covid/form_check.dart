import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/check.dart';
import '../../provider/provider_check.dart';
import '../../result/collect_check.dart';

class CheckUp {
  String date;
  String time;
  String weight;
  String temp;
  String type;

  CheckUp({
    required this.date,
    required this.time,
    required this.weight,
    required this.temp,
    required this.type,
  });

  // Convert Check object into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'weight': weight,
      'temp': temp,
      'type': type,
    };
  }
}

class CheckScreen extends StatefulWidget {
  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  final GlobalKey<FormState> checkKey = GlobalKey<FormState>();
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController weightinput = TextEditingController();
  TextEditingController tempinput = TextEditingController();
  String typeinput = '';
  // Firestore instance
  final firestoreInstance = FirebaseFirestore.instance;

  // Add Check data to Firestore
  void addCheckToFirestore(CheckUp check) {
    firestoreInstance.collection("checks").add(check.toMap()).then((value) {
      print(value.id);
    });
  }

  @override
  void initState() {
    super.initState();
    dateinput.text = "";
    timeinput.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('บันทึกผลตรวจ'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: checkKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[50],
                ),
                child: Center(
                  child: TextFormField(
                    controller: dateinput,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today),
                      labelText: "วัน/เดือน/ปี",
                      contentPadding: EdgeInsets.all(8.0),
                      border: InputBorder.none,
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
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        setState(() {
                          dateinput.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[50],
                ),
                child: Center(
                  child: TextFormField(
                    controller: timeinput,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.timer),
                      labelText: "เวลาที่บันทึก",
                      contentPadding: EdgeInsets.all(8.0),
                      border: InputBorder.none,
                    ),
                    validator: RequiredValidator(errorText: "กรุณาระบุเวลา"),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        String formattedTime =
                            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                        setState(() {
                          timeinput.text = formattedTime;
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                ),
              ),
              const SizedBox(height: 10),
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
                  validator: RequiredValidator(errorText: "กรุณาป้อนอุณหภูมิ"),
                ),
              ),
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
                        value: 'Negative',
                        groupValue: typeinput,
                        activeColor: Colors.red[400],
                        title: const Text('ผลเป็นลบ'),
                        onChanged: (val) {
                          setState(() {
                            typeinput = val!;
                          });
                        },
                      ),
                    ),
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
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (checkKey.currentState!.validate()) {
                          if (typeinput.isNotEmpty) {
                            CheckUp report1 = CheckUp(
                              date: dateinput.text,
                              time: timeinput.text,
                              weight: weightinput.text,
                              temp: tempinput.text,
                              type: typeinput,
                            );
                            // Add the report to Firestore
                            addCheckToFirestore(report1);

                            // var date = dateinput.text;
                            // var time = timeinput.text;
                            // var weight = weightinput.text;
                            // var temp = tempinput.text;
                            // var type = typeinput;

                            // CheckModel report = CheckModel(
                            //   date: date,
                            //   time: time,
                            //   weight: weight,
                            //   temp: temp,
                            //   type: type,
                            // );
                        
                            // var provider = Provider.of<CheckProvider>(context,
                            //     listen: false);
                            // provider.addCheckModel(report);

                            // Navigator.pop(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           CollectCheck(check: check)),
                            // );

                            // Navigate to another screen or show a success message
                            Navigator.pop(context);
                          } else {
                            // Show a warning message
                          }
                        }
                      },
                      child: Text('บันทึก'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('ยกเลิก'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

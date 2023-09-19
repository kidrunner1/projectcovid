//หน้าบันทึกผลตรวจโควิด ประจำวัน

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:tracker_covid_v1/screen/getdata_daily/result_detail.dart';

// enum ProducTypeEnum { positive, negative }

class Memo extends StatefulWidget {
  const Memo({super.key});

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  late String message;
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController numberinput = TextEditingController();
  TextEditingController tempinput = TextEditingController();
  // ProducTypeEnum? _producTypeEnum;
  String type = '';
  final memoKey = GlobalKey<FormState>();
  // ignore: unused_field
  final TextEditingController _latitude = TextEditingController();
  // ignore: unused_field
  final TextEditingController _longitude = TextEditingController();

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
    timeinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 223, 226, 1),
        appBar: AppBar(
            title: const Text('บันทึกผลตรวจโควิด-19 ประจำวัน'),
            backgroundColor: Colors.red[200]),
        body: SingleChildScrollView(
            child: Form(
                key: memoKey,
                child: Column(children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                        borderRadius: BorderRadius.circular(10),
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
                        validator:
                            RequiredValidator(errorText: "กรุณาระบุเวลา"),
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
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[50],
                      ),
                      child: TextFormField(
                        controller: numberinput,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.scale),
                          labelText: "น้ำหนักปัจจุบัน",
                          contentPadding: EdgeInsets.all(8.0),
                          border: InputBorder.none,
                        ),
                        validator:
                            RequiredValidator(errorText: "กรุณาป้อนน้ำหนัก"),
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
                              value: 'positive',
                              groupValue: type,
                              activeColor: Colors.red[400],
                              title: const Text('ผลเป็นบวก'),
                              onChanged: (val) {
                                setState(() {
                                  type = val!;
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                              contentPadding: const EdgeInsets.all(0.0),
                              value: 'negative',
                              groupValue: type,
                              activeColor: Colors.red[400],
                              title: const Text('ผลเป็นบวก'),
                              onChanged: (val) {
                                setState(() {
                                  type = val!;
                                });
                              }),
                        ),
                        // Expanded(
                        //   child: RadioListTile<ProducTypeEnum>(
                        //       contentPadding: const EdgeInsets.all(0.0),
                        //       value: ProducTypeEnum.positive,
                        //       groupValue: _producTypeEnum,
                        //       activeColor: Colors.red[400],
                        //       title: const Text('ผลเป็นบวก'),
                        //       onChanged: (val) {
                        //         setState(() {
                        //           _producTypeEnum = val;
                        //         });
                        //       }),
                        // ),
                        // Expanded(
                        //   child: RadioListTile<ProducTypeEnum>(
                        //       contentPadding: const EdgeInsets.all(0.0),
                        //       value: ProducTypeEnum.negative,
                        //       groupValue: _producTypeEnum,
                        //       activeColor: Colors.red[400],
                        //       title: const Text('ผลเป็นลบ'),
                        //       onChanged: (val) {
                        //         setState(() {
                        //           _producTypeEnum = val;
                        //         });
                        //       }),
                        // ),
                      ],
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
                                  if (memoKey.currentState!.validate()) {
                                    // ignore: unnecessary_null_comparison
                                    if (type == null) {
                                      // กรณีผลตรวจไม่ถูกเลือก
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        title: 'ผลตรวจไม่ถูกเลือก',
                                        desc: 'กรุณาเลือกผลตรวจ',
                                        btnOkOnPress: () {},
                                      ).show();
                                    } else {
                                      // กรอกข้อมูลสำเร็จ
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        title: 'บันทึกข้อมูลเรียบร้อย!!',
                                        desc:
                                            'พรุ่งนี้อย่าลืมมาบันทึกผลด้วยกันอีกนะ\nคำแนะนำ!!!\n\n1. แยกห้องพัก ของใช้ส่วนตัวกับผู้อื่น (หากแยกไม่ได้ ควรอยู่ให้ห่างจากผู้อื่นมากที่สุด)\n2. ห้ามออกจากที่พักและปฏิเสธผู้ใดมาเยี่ยมที่บ้าน\n3. หลีกเลี่ยงการรับประทานอาหารร่วมกัน\n4. สวมหน้ากากอนามัยตลอดเวลา หากไม่ได้อยู่คนเดียว\n5. เว้นระยะห่าง อย่างน้อย 2 เมตร\n6. แยกซักเสื้อผ้า รวมไปถึงควรใช้ห้องน้ำแยกจากผู้อื่น',
                                        btnOkOnPress: () {
                                          memoKey.currentState!.save();
                                          ({
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Detail(
                                                  dateinput.text,
                                                  timeinput.text,
                                                  numberinput.text,
                                                  tempinput.text,
                                                  type,
                                                ),
                                              ),
                                            )
                                          });
                                        },
                                      ).show();
                                    }
                                  }
                                }),
                            const SizedBox(height: 10),
                            AnimatedButton(
                              text: 'ยกเลิก',
                              color: Colors.red,
                              pressEvent: () {},
                            ),
                          ]))
                ]))));
  }
}

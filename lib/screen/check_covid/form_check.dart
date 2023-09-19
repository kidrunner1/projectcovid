//หน้าบันทึกผลตรวจโควิด ประจำวัน

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

// enum ProducTypeEnum { positive, negative }

class FormCheck extends StatefulWidget {
  const FormCheck({super.key});

  @override
  State<FormCheck> createState() => _FormCheckState();
}

class _FormCheckState extends State<FormCheck> {
  late String message;
  final dateinput = TextEditingController();
  final timeinput = TextEditingController();
  final weightinput = TextEditingController();
  final tempinput = TextEditingController();
  String typeinput = '';
  final checkKey = GlobalKey<FormState>();

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
                        key: checkKey,
                        child: Column(
                          children: [
                          const SizedBox(height: 20),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[50],
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller:
                                      dateinput, //editing controller of this TextField
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons
                                        .calendar_today), //icon of text field
                                    labelText: "วัน/เดือน/ปี",
                                    contentPadding: EdgeInsets.all(8.0),
                                    border: InputBorder.none,
                                    //label text of field
                                  ),
                                  validator: RequiredValidator(
                                      errorText: "กรุณาระบุวัน/เดือน/ปี"),
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
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
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
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[50],
                              ),
                              child: Center(
                                  child: TextFormField(
                                controller:
                                    timeinput, //editing controller of this TextField
                                decoration: const InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.timer), //icon of text field
                                  labelText: "เวลาที่บันทึก",
                                  contentPadding: EdgeInsets.all(8.0),
                                  border:
                                      InputBorder.none, //label text of field
                                ),
                                validator: RequiredValidator(
                                    errorText: "กรุณาระบุเวลา"),
                                readOnly:
                                    true, //set it true, so that user will not able to edit text
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );

                                  if (pickedTime != null) {
                                    print(pickedTime
                                        .format(context)); //output 10:51 PM
                                    DateTime parsedTime = DateFormat.jm().parse(
                                        pickedTime.format(context).toString());
                                    //converting to DateTime so that we can further format on different pattern.
                                    print(
                                        parsedTime); //output 1970-01-01 22:53:00.000
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
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
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
                                validator: RequiredValidator(
                                    errorText: "กรุณาป้อนน้ำหนัก"),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
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
                                validator: RequiredValidator(
                                    errorText: "กรุณาป้อนอุณหภูมิ"),
                              )),
                          const SizedBox(height: 10),
                          const Text(
                            "ผลตรวจ ATK วันนี้",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 20),
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
                                      }),
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
                                      }),
                                ),
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
                                        pressEvent: ()  {
                                          if (checkKey.currentState!
                                              .validate())  {
                                            if (typeinput.isEmpty) {
                                              // กรณีผลตรวจไม่ถูกเลือก
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.warning,
                                                title: 'ผลตรวจไม่ถูกเลือก',
                                                desc: 'กรุณาเลือกผลตรวจ',
                                                btnOkOnPress: () {},
                                              ).show();
                                            } else {
                                              // กรอกข้อมูลสำเร็จ
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.success,
                                                title:
                                                    'บันทึกข้อมูลเรียบร้อย!!',
                                                desc:
                                                    'พรุ่งนี้อย่าลืมมาบันทึกผลด้วยกันอีกนะ\nคำแนะนำ!!!\n\n1. แยกห้องพัก ของใช้ส่วนตัวกับผู้อื่น (หากแยกไม่ได้ ควรอยู่ให้ห่างจากผู้อื่นมากที่สุด)\n2. ห้ามออกจากที่พักและปฏิเสธผู้ใดมาเยี่ยมที่บ้าน\n3. หลีกเลี่ยงการรับประทานอาหารร่วมกัน\n4. สวมหน้ากากอนามัยตลอดเวลา หากไม่ได้อยู่คนเดียว\n5. เว้นระยะห่าง อย่างน้อย 2 เมตร\n6. แยกซักเสื้อผ้า รวมไปถึงควรใช้ห้องน้ำแยกจากผู้อื่น',
                                                btnOkOnPress: () {
                                                
                                                },
                                              ).show();
                                            }
                                          }
                                        }),
                                    const SizedBox(height: 10),
                                    AnimatedButton(
                                      text: 'ยกเลิก',
                                      color: Colors.red,
                                      pressEvent: () {
                                        
                                      },
                                    ),
                                  ]))
                        ]))));
          }

        }

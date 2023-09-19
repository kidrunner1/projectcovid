// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class EditAppoints extends StatefulWidget {
//   final String initialFristname;
//   final String initialLastname;
//   final String initialDate;
//   final String initialSelectedTime;

//    EditAppoints({
//     required this.initialFristname,
//     required this.initialLastname,
//     required this.initialDate,
//     required this.initialSelectedTime,
//   });

//   @override
//   _EditAppointsState createState() => _EditAppointsState();
// }

// class _EditAppointsState extends State<EditAppoints> {
//   final TextEditingController fristnameController = TextEditingController();
//   final TextEditingController lastnameController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   String selectedTime = '';

//   @override
//   void initState() {
//     super.initState();
//     fristnameController.text = widget.initialFristname;
//     lastnameController.text = widget.initialLastname;
//     dateController.text = widget.initialDate;
//     selectedTime = widget.initialSelectedTime;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('แก้ไขข้อมูลนัดรับยา'),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           // ... ส่วนอื่น ๆ ของฟอร์มแก้ไขข้อมูล ...
//           child: Column(
//     children: [
//       TextFormField(
//         controller: fristnameController,
//         decoration: InputDecoration(
//           labelText: 'ชื่อ',
//         ),
//       ),
//       TextFormField(
//         controller: lastnameController,
//         decoration: InputDecoration(
//           labelText: 'นามสกุล',
//         ),
//       ),
//       TextFormField(
//         controller: dateController,
//         decoration: InputDecoration(
//           labelText: 'วัน/เดือน/ปี',
//         ),
//           onTap: () async {
//            DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         locale: const Locale("th", "TH"),
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(
//                             2000), //DateTime.now() - not to allow to choose before today.
//                         lastDate: DateTime(2101));

//                     if (pickedDate != null) {
//                       print(
//                           pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
//                       String formattedDate =
//                           DateFormat('dd-MM-yyyy').format(pickedDate);
//                       print(
//                           formattedDate); //formatted date output using intl package =>  2021-03-16
//                       //you can implement different kind of Date Format here according to your requirement

//                       dateController.text =
//                           formattedDate; //set output date to TextField value.
//                     } else {
//                       print("Date is not selected");
//                     }
//         },
//       ),
//       const Text('ช่วงเวลาเข้ารับยา'),
//      SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Column(children: <Widget>[
//                   RadioListTile(
//                     title: Text('12.00น.'),
//                     value: '12.00น.',
//                     groupValue: selectedTime,
//                     onChanged: (val) {
//                       setState(() {
//                         selectedTime = val!;
//                       });
//                     },
//                   ),
//                   RadioListTile(
//                     title: Text('13.00น.'),
//                     value: '13.00น.',
//                     groupValue: selectedTime,
//                     onChanged: (val) {
//                     setState(() {
//                         selectedTime = val!;
//                       });
//                     },
//                   ),
//                   RadioListTile(
//                     title: Text('14.00น.'),
//                     value: '14.00น.',
//                     groupValue: selectedTime,
//                     onChanged: (val) {
//                      setState(() {
//                         selectedTime = val!;
//                       });
//                     },
//                   ),
//                   RadioListTile(
//                     title: Text('15.00น.'),
//                     value: '15.00น.',
//                     groupValue: selectedTime,
//                     onChanged: (val) {
//                      setState(() {
//                         selectedTime = val!;
//                       });
//                     },
//                   ),
//                 ]),
//               ),
//       ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditAppoints(
//           initialFristname: fristnameController.text,
//           initialLastname: lastnameController.text,
//           initialDate: dateController.text,
//           initialSelectedTime: selectedTime,
//         ),
//       ),
//     );
//   },
//   child: const Text('แก้ไขข้อมูล'),
  
// ),
// ElevatedButton(
//   onPressed: () {
//     // โค้ดสำหรับบันทึกการแก้ไขข้อมูล
//     // อัปเดตข้อมูลและบันทึก
//     // ...

//     Navigator.pop(context);
//   },
//   child: Text('บันทึก'),
// ),


//     ],
//   ),
// ),
//         ),
//       );
//   }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// // ignore: must_be_immutable
// class MyForm extends StatefulWidget {
//   String args;
//   String time;
//   String number;
//   String temp;

//   MyForm(this.args, this.time, this.number, this.temp, {super.key});

//   @override
//   State<MyForm> createState() => _MyFormState();
// }

// class _MyFormState extends State<MyForm> {
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('บันทึกข้อมูล')),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: ListView(
//           children: [
//             Text("Add date in the Form"),
//             SizedBox(height: 20),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

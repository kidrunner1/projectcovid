// import 'package:flutter/material.dart';
// import 'package:tracker_covid_v1/model/appoints.dart';
// import 'package:tracker_covid_v1/screen/appointment/edit_appoints.dart';
// import 'package:tracker_covid_v1/screen/appointment/form_appoints.dart';

// // ignore: must_be_immutable
// class CollectAppoints extends StatelessWidget {
// final Appointments appointment;

//  CollectAppoints({required this.appointment });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('บันทึกการเข้ารับยา'),
//         backgroundColor: Color.fromARGB(255, 239, 154, 154),
//       ),
//       backgroundColor: Colors.red[100],
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10), color: Colors.white),
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.all(10),
//                 padding: EdgeInsets.all(8),
//                 alignment: Alignment.topLeft,
//                 color: Colors.pink[100],
//                 child: Text("ชื่อ: ${appointment.fristname} ${appointment.lastname}", style: TextStyle(fontSize: 16)),
//               ),
              
//               Container(
//                 margin: EdgeInsets.all(10),
//                 padding: EdgeInsets.all(8),
//                 alignment: Alignment.topLeft,
//                 color: Colors.pink[100],
//                 child: Text("วัน/เดือน/ปี: ${appointment.date} ", style: TextStyle(fontSize: 16)),
//               ),
//                Container(
//                 margin: EdgeInsets.all(10),
//                 padding: EdgeInsets.all(8),
//                 alignment: Alignment.topLeft,
//                 color: Colors.pink[100],
//                 child: Text("เวลา: ${appointment.selectedTime}", style: TextStyle(fontSize: 16)),
//               ),
//               ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditAppoints(
//           initialFristname: appointment.fristname,
//           initialLastname: appointment.lastname,
//           initialDate: appointment.date,
//           initialSelectedTime: appointment.selectedTime,
//         ),
//       ),
//     );
//   },
//   child: Text('แก้ไขข้อมูล'),
// ),

//             ],
//           ),
          
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//           foregroundColor: Colors.black,
//           backgroundColor: Colors.red[50],
//           highlightElevation: 40,
//           elevation: 12,
//           tooltip: 'เพิ่ม',
//           child: Icon(Icons.add_box_outlined,color: Colors.grey[700],),
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FormAppointments(),
//                 ));
//           }),
    
//     );
//   }
// }

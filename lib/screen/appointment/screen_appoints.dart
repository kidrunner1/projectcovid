
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:tracker_covid_v1/model/appoints.dart';
// import 'package:tracker_covid_v1/result/collect_appoints.dart';
// import '../../provider/provider_appoints.dart';
// import 'form_appoints.dart';

// class ScreenAppoints extends StatefulWidget {
//   const ScreenAppoints({super.key});

//   @override
//   State<ScreenAppoints> createState() => _ScreenAppointsState();
// }

// class _ScreenAppointsState extends State<ScreenAppoints> {
//   void _deleteAppointments(BuildContext context, int index) {
//     Provider.of<AppointmentsProvider>(context, listen: false)
//         .deleteAppointments(index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red[100],
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 239, 154, 154),
//         title: Text("ติดต่อนัดรับยา"),
//       ),
//       body: Consumer(builder: ((context, AppointmentsProvider provider, child) {
//         var count = provider.appointments.length;
//         if (count <= 0) {
//           return const Center(
//               child: Text(
//             "ไม่พบข้อมูล",
//             style: TextStyle(fontSize: 35),
//           ));
//         } else {
//           return ListView.builder(
//               itemCount: provider.appointments.length,
//               itemBuilder: (context, int index) {
//                 Appointments data = provider.appointments[index];
//                 final dayNumber = count-index ;
//                 return Card(
//                   elevation: 5,
//                   margin: EdgeInsets.all(8),
//                   child: 
//                       SingleChildScrollView(
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 padding: EdgeInsets.all(20),
//                                 child: SizedBox(
//                                   height: 60,
//                                   child: ElevatedButton(
//                                     child: Text('บันทึกผลวันที่ ${dayNumber}'),
//                                     style: ElevatedButton.styleFrom(
//                                       foregroundColor: Colors.black,
//                                       backgroundColor: Colors.grey[200],
//                                       textStyle: const TextStyle(
//                                           fontSize: 20,
//                                           fontStyle: FontStyle.normal),
//                                     ),
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => CollectAppoints(
//                                             appointment: data,
//                                           ),
//                                         ),
//                                       );
//                                     },
                                    
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Provider.of<AppointmentsProvider>(context,
//                                         listen: false)
//                                     .deleteAppointments(index);
//                               },
//                               child: const Icon(
//                                 Icons.delete,
//                                 color: Colors.red,
//                               ),
//                             ),
                            
//                           ],
//                         ),
//                       ),
                    
//                   );
//               });
//         }
//       }
//       )),floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.red[200],
//           child: Icon(Icons.add),
//           onPressed: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return FormAppointments();
//             }));
//           }),
//     );
//   }
// }

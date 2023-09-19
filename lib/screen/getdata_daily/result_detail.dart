// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'record_daily.dart';

// ignore: must_be_immutable
class Detail extends StatefulWidget {
  // Detail({super.key});
  String args;
  String time;
  String number;
  String temp;
  // ProducTypeEnum? button;
  String type;

  Detail(this.args, this.time, this.number, this.temp, this.type, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<Detail> createState() => _DetailState(args, time, number, temp, type);
}

class _DetailState extends State<Detail> {
  String args;
  String time;
  String number;
  String temp;
  // ProducTypeEnum button;
  String type;
  _DetailState(this.args, this.time, this.number, this.temp, this.type);
  @override
  Widget build(BuildContext context) {
    // Object? datein = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดการบันทึกผล'),
        backgroundColor: Color.fromARGB(255, 239, 154, 154),
      ),
      backgroundColor: Colors.red[100],
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(8),
                alignment: Alignment.topLeft,
                color: Colors.amber[100],
                child: Text("วัน/เดือน/ปี: $args ",
                    style: TextStyle(fontSize: 16)),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(8),
                alignment: Alignment.topLeft,
                color: Colors.pink[100],
                child: Text("เวลา: $time น.", style: TextStyle(fontSize: 16)),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(8),
                alignment: Alignment.topLeft,
                color: Colors.blue[100],
                child: Text("น้ำหนัก: $number กิโลกรัม",
                    style: TextStyle(fontSize: 16)),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(8),
                alignment: Alignment.topLeft,
                color: Colors.deepPurple[100],
                child: Text("อุณหภูมิร่างกาย: $temp องศาเซลเซียส",
                    style: TextStyle(fontSize: 16)),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(8),
                alignment: Alignment.topLeft,
                color: Colors.deepPurple[100],
                child: Text("ผลตรวจ: $type ", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.black,
          backgroundColor: Colors.red[50],
          highlightElevation: 40,
          elevation: 12,
          tooltip: 'แก้ไข',
          child: Icon(
            Icons.add,
            color: Colors.grey[700],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Memo(),
                ));
          }),
    );
  }
}


// import 'package:covid_data/page/check_covid.dart';
// import 'package:flutter/material.dart';

// class Detail extends StatefulWidget {
//   String date;
//   String time;
//   String number;
//   String temp;
//   String type;

//   Detail(this.date, this.time, this.number, this.temp, this.type, {super.key});
//   @override
//   // ignore: no_logic_in_create_state
//   State<Detail> createState() => _DetailState(date, time, number, temp, type);
// }

// class _DetailState extends State<Detail> {
//   String date;
//   String time;
//   String number;
//   String temp;
//   // ProducTypeEnum button;
//   String type;
//   _DetailState(this.date, this.time, this.number, this.temp, this.type);


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('รายละเอียดการบันทึกผล'),
//         backgroundColor: Color.fromARGB(255, 239, 154, 154),
//       ),
//       backgroundColor: Colors.red[100],
//       body: StreamBuilder<QuerySnapshot>(
//         stream:FirebaseFirestore.instance.collection('covid_results').snapshots(),
//         builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return CircularProgressIndicator();
//           }

//           final results = snapshot.data!.docs;
//           List<Widget> resultWidgets = [];

//           for (var result in results) {
//             final date = result['date'];
//             final time = result['time'];
//             final number = result['number'];
//             final temp = result['temp'];
//             final type = result['type'];

//             resultWidgets.add(
//               Container(
//                 margin: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       padding: EdgeInsets.all(8),
//                       alignment: Alignment.topLeft,
//                       color: Colors.amber[100],
//                       child: Text("วัน/เดือน/ปี: $date ",
//                           style: TextStyle(fontSize: 16)),
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       padding: EdgeInsets.all(8),
//                       alignment: Alignment.topLeft,
//                       color: Colors.pink[100],
//                       child: Text("เวลา: $time น.",
//                           style: TextStyle(fontSize: 16)),
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       padding: EdgeInsets.all(8),
//                       alignment: Alignment.topLeft,
//                       color: Colors.blue[100],
//                       child: Text("น้ำหนัก: $number กิโลกรัม",
//                           style: TextStyle(fontSize: 16)),
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       padding: EdgeInsets.all(8),
//                       alignment: Alignment.topLeft,
//                       color: Colors.deepPurple[100],
//                       child: Text("อุณหภูมิร่างกาย: $temp องศาเซลเซียส",
//                           style: TextStyle(fontSize: 16)),
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       padding: EdgeInsets.all(8),
//                       alignment: Alignment.topLeft,
//                       color: Colors.deepPurple[100],
//                       child: Text("ผลตรวจ: $type ",
//                           style: TextStyle(fontSize: 16)),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           return Scaffold(
//             appBar: AppBar(
//               title: Text('รายละเอียดการบันทึกผล'),
//               backgroundColor: Color.fromARGB(255, 239, 154, 154),
//             ),
//             backgroundColor: Colors.red[100],
//             body: ListView(
//               children: resultWidgets,
//             ),
//             floatingActionButton: FloatingActionButton(
//               foregroundColor: Colors.black,
//               backgroundColor: Colors.red[50],
//               highlightElevation: 40,
//               elevation: 12,
//               tooltip: 'แก้ไข',
//               child: Icon(Icons.add, color: Colors.grey[700]),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Memo(),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
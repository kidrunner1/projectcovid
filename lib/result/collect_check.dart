import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/model/check.dart';
import 'package:tracker_covid_v1/screen/check_covid/form_check.dart';
import '../screen/check_covid/edit_check.dart';

class CollectCheck extends StatelessWidget {
  final CheckModel check;

  CollectCheck({required this.check});

  @override
  Widget build(BuildContext context) {
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
              _buildInfoContainer('วันที่บันทึกอาการ', check.date, Colors.amber[100]!),
              _buildInfoContainer('เวลาที่บันทึก', '${check.time} น.', Colors.pink[100]!),
              _buildInfoContainer('น้ำหนักปัจจุบัน', '${check.weight} กิโลกรัม', Colors.blue[100]!),
              _buildInfoContainer('อุณหภูมิร่างกายปัจจุบัน', '${check.temp} องศาเซลเซียส', Colors.deepPurple[100]!),
              _buildInfoContainer('ผลตรวจ ATK วันนี้', '${check.type}', Colors.deepOrange[100]!),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCheck(
                        initialDate: check.date,
                        initialTime: check.time,
                        initialWeight: check.weight,
                        initialTemp: check.temp,
                        initialType: check.type
                      ),
                    ),
                  );
                },
                child: Text('แก้ไขข้อมูล'),
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
          tooltip: 'บันทึกผล',
          child: Icon(Icons.add, color: Colors.grey[700]),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CheckScreen(),
              ),
            );
          }),
    );
  }

  Widget _buildInfoContainer(String title, String data, Color color) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      alignment: Alignment.topLeft,
      color: color,
      child: Text('$title: $data', style: TextStyle(fontSize: 16)),
    );
  }
}

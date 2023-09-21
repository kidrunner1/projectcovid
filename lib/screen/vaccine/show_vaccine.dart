import 'package:flutter/material.dart';

class VaccineRecordsPage extends StatefulWidget {
  @override
  _VaccineRecordsPageState createState() => _VaccineRecordsPageState();
}

class _VaccineRecordsPageState extends State<VaccineRecordsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Fetch and display the saved vaccine records
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการนัดรับวัคซีน'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with your data's length
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Data $index'), // Replace with your data
          );
        },
      ),
    );
  }
}

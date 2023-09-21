import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/vaccine/show_vaccine.dart';
import 'package:intl/intl.dart'; 

class ScreenVaccine extends StatefulWidget {
  @override
  _ScreenVaccineState createState() => _ScreenVaccineState();
}

class _ScreenVaccineState extends State<ScreenVaccine> {
  String? selectedHospital;
  String? selectedVaccine;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final List<String> vaccines = ['Sinavac', 'Pfizer', 'Moderna', 'AstraZeneca', 'Sinopharm'];
_selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    } else {
      print("Date is not selected");
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('นัดรับวัคซีน'),
        backgroundColor: Colors.red[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('เลือกโรงพยาบาล'),
              value: selectedHospital,
              items: ['โรงพยาบาล A', 'โรงพยาบาล B', 'โรงพยาบาล C']
                  .map((hospital) => DropdownMenuItem<String>(
                        value: hospital,
                        child: Text(hospital),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedHospital = value!;
                });
              },
            ),
            DropdownButton<String>(
              hint: Text('เลือกวัคซีน'),
              value: selectedVaccine,
              items: vaccines
                  .map((vaccine) => DropdownMenuItem<String>(
                        value: vaccine,
                        child: Text(vaccine),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedVaccine = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('เลือกวันที่: ${selectedDate.toLocal().toString().split(' ')[0]}'),
            ),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('เลือกเวลา: ${selectedTime.format(context)}'),
            ),
            ElevatedButton(
  onPressed: () {
    print('โรงพยาบาลที่เลือก: $selectedHospital');
    print('วัคซีนที่เลือก: $selectedVaccine');
    print('วันที่รับวัคซีน: ${selectedDate.toLocal().toString().split(' ')[0]}');
    print('เวลาที่รับวัคซีน: ${selectedTime.format(context)}');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VaccineRecordsPage()),
    );
  },
  child: Text('บันทึก'),
)
          ],
        ),
      ),
    );
  }
}

_selectTime(BuildContext context) {
}

void main() => runApp(MaterialApp(home: ScreenVaccine()));

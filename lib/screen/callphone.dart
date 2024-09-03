import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/model/callphone.dart';
import 'package:url_launcher/url_launcher.dart';

class CallPhone extends StatelessWidget {
  CallPhone({super.key});

  final List<Map<String, String>> numbers = EmergencyNumbers.numbers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "สายด่วน",
          style: GoogleFonts.prompt(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: EmergencyNumbers.numbers.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(EmergencyNumbers.numbers[index]['name']!,
                      style: GoogleFonts.prompt(fontSize: 16)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(numbers[index]['number']!,
                        style: GoogleFonts.prompt(fontSize: 16)),
                  ),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(numbers[index]['image']!),
                  ),
                  trailing: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(Icons.call),
                    label: Text('โทร', style: GoogleFonts.prompt()),
                    onPressed: () async {
                      String num = numbers[index]['number']!;
                      await FlutterPhoneDirectCaller.callNumber(num);
                      launch('tel://$num');
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.pink[50],
    );
  }
}

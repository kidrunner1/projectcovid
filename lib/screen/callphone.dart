import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:tracker_covid_v1/model/callphone.dart';
import 'package:url_launcher/url_launcher.dart';

class CallPhone extends StatelessWidget {
  CallPhone({super.key});

  final List<Map<String, String>> numbers = EmergencyNumbers.numbers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "สายด่วน",
          ),
          centerTitle: true,
          backgroundColor: Colors.red[300],
        ),
        body: ListView.builder(
          itemCount: EmergencyNumbers.numbers.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration:BoxDecoration(
                
                borderRadius: BorderRadius.circular(20),
                color: Colors.red[200],
                ),
                
              child: SingleChildScrollView(
                child: ListTile(
                  title: Text(EmergencyNumbers.numbers[index]['name']!, ),
                  titleTextStyle:const TextStyle(
                    color: Colors.black,
                    fontSize: 16),
                  subtitle: Text(numbers[index]['number']!,),
                  subtitleTextStyle:const TextStyle(
                    fontSize: 16,
                    fontWeight:FontWeight.bold),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(numbers[index]['image']!),
                  ),
                  trailing: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      padding:const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                    ),
                    child: const Text('โทร'),
                    onPressed: () async {
                      String num = numbers[index]['number']!;
                      // ignore: deprecated_member_use
                      launch('tel://$num');
                      await FlutterPhoneDirectCaller.callNumber(num);
                    },
                  ),
                ),
              ),
            );
          },
        ));
  }
}

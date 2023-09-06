import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void _makePhoneCall(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class CallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "สายด่วน",
          ),
          backgroundColor: const Color.fromARGB(255, 255, 97, 97),
        ),
        body: Container(
          // พื้นหลัง
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, -1),
              end: Alignment(0, 1),
              colors: <Color>[Color(0xfff76666), Color(0xffedc4c4)],
              stops: <double>[0.083, 0.813],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(62, 215, 120, 120),
                offset: Offset(0, 4),
                blurRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //ปรึกษาสุขภาพจิต
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 218, 90, 90),
                      borderRadius: BorderRadius.circular(20)),
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 70,
                              height: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                    'https://gdcatalog.go.th/assets/images/organization_logo/sukkapabjitt.png'),
                              )),
                          const SizedBox(
                            width: 25,
                          ),
                          const Text(
                            'ปรึกษาสุขภาพจิต',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NotoSansThai",
                                color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final Uri url = Uri(
                            scheme: 'tel',
                            path: "1323",
                          );
                          if (await canLaunch(url.toString())) {
                            // Corrected this line
                            await launch(url.toString());
                          } else {
                            print('cannot launch this url');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 7, 143, 21),
                        ),
                        child: const Text(
                          '1323',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

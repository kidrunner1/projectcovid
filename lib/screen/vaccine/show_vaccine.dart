import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/vaccine/screen2_vaccine.dart';
import 'package:tracker_covid_v1/screen/vaccine/screen_vaccine.dart';

class ShowData_VaccineLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text(
          'สถานที่รับวัคซีน',
          style: GoogleFonts.prompt(fontSize: 22),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 3, // Add elevation for a shadow effect
              margin: EdgeInsets.all(10), // Adjust margin as needed
              child: ListTile(
                leading: Image.asset('assets/images/logo_hospital.png'),
                title: Text(
                  'วัคซีน (รอบที่ 1)',
                  style: GoogleFonts.prompt(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('16 ธันวาคม 2566',
                        style: GoogleFonts.prompt(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    SizedBox(height: 3),
                    Text('Sinavac(เข็มที่ 1) + Sinavac(เข็มที่ 2)',
                        style: GoogleFonts.prompt(
                          fontSize: 17,
                          //fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 48, 110, 50),
                        )),
                    SizedBox(height: 5),
                    Text('จำกัดสิทธิ์แค่ 120 คน/รอบ',
                        style: GoogleFonts.prompt(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to the ShowDetail_Location page when the button is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowDetail_Location(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 54, 221,
                              157), // Background color of the button
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Rounded button shape
                          ),
                        ),
                        child: Text(
                          'รายละเอียด',
                          style: GoogleFonts.prompt(
                            fontSize: 16,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 3, // Add elevation for a shadow effect
              margin: EdgeInsets.all(10), // Adjust margin as needed
              child: ListTile(
                leading: Image.asset('assets/images/logo_hospital.png'),
                title: Text(
                  'วัคซีน (รอบที่ 2)',
                  style: GoogleFonts.prompt(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('20 มกราคม 2567',
                        style: GoogleFonts.prompt(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    SizedBox(height: 3),
                    Text('Sinavac(เข็มที่ 1) + AstraZeneca(เข็มที่ 2)',
                        style: GoogleFonts.prompt(
                          fontSize: 17,
                          //fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 48, 110, 50),
                        )),
                    SizedBox(height: 5),
                    Text('จำกัดสิทธิ์แค่ 120 คน/รอบ',
                        style: GoogleFonts.prompt(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to the ShowDetail_Location page when the button is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowDetail_Location2(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 54, 221,
                              157), // Background color of the button
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Rounded button shape
                          ),
                        ),
                        child: Text(
                          'รายละเอียด',
                          style: GoogleFonts.prompt(
                            fontSize: 16,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Add more Card/ListTile combinations as needed
        ],
      ),
    );
  }
}

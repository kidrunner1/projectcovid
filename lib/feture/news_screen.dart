import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/screen/appointment/form_appoints.dart';

import 'package:tracker_covid_v1/screen/call_page.dart';
import 'package:tracker_covid_v1/screen/check_covid/form_check.dart';
import 'package:tracker_covid_v1/screen/covid_data_screen.dart';
import 'package:tracker_covid_v1/screen/evaluate_symptoms.dart';
import 'package:tracker_covid_v1/screen/track_covid.dart';


class NewsScreens extends StatefulWidget {
  const NewsScreens({Key? key}) : super(key: key);

  @override
  State<NewsScreens> createState() => _NewsScreensState();
}

class _NewsScreensState extends State<NewsScreens> {
  int _currentPage = 0;
  List<String> _imageUrls = [
    "https://ecobnb.com/blog/app/uploads/sites/3/2020/01/nature.jpg",
    'https://w1.med.cmu.ac.th/family/wp-content/uploads/2020/09/Covid-19-scaled.jpg',
    'https://www.klonghaecity.go.th/files/com_networknews/2020-12_56ff228cf695781.jpg',
  ];

  Widget _buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_imageUrls.length, (index) {
        return Container(
          width: _currentPage == index ? 10.0 : 8.0,
          height: _currentPage == index ? 10.0 : 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            color: _currentPage == index ? Colors.red[300] : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget _iconContainer({
    required IconData iconData,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 45,
              color: Colors.brown[800],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.prompt(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
                items: _imageUrls.map((url) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.network(url, fit: BoxFit.cover),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              _buildCarouselIndicator(),
              SizedBox(height: 25),
              _buildNavigationRow1(),
              SizedBox(height: 25),
              _buildNavigationRow2(),
              SizedBox(height: 25),
              _buildNavigationRow3(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationRow(Widget child) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: child,
    );
  }

  Widget _buildNavigationRow1() {
    return _buildNavigationRow(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconContainer(
              iconData: Icons.assignment_outlined,
              label: 'ประเมินความเสี่ยง',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Evaluate_Symptoms()));
              }),
          SizedBox(width: 12),
          _iconContainer(
              iconData: Icons.trending_up,
              label: 'จำนวนผู้ติดเชือ',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CovidTrackerScreen()));
              }),
          SizedBox(width: 12),
          _iconContainer(
              iconData: FontAwesomeIcons.syringe,
              label: 'นัดฉีดวัคซีน',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              }),
        ],
      ),
    );
  }

  Widget _buildNavigationRow2() {
    return _buildNavigationRow(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconContainer(
              iconData: FontAwesomeIcons.ambulance,
              label: 'สายด่วน',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CallPage()));
              }),
          SizedBox(width: 12),
          _iconContainer(
              iconData: FontAwesomeIcons.pills,
              label: 'ติดต่อเข้ารับยา',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FormAppointments()));
              }),
          SizedBox(width: 12),
          _iconContainer(
              iconData: Icons.assignment,
              label: 'บันทึกผลตรวจประจำวัน',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  FormCheck()));
              }),
        ],
      ),
    );
  }

  Widget _buildNavigationRow3() {
    return _buildNavigationRow(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconContainer(
              iconData: Icons.calendar_month,
              label: 'การนัดของคุณ',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CovidDataScreen()));
              }),
          SizedBox(width: 12),
          _iconContainer(
              iconData: FontAwesomeIcons.locationDot,
              label: 'ภายในจังหวัด',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CovidDataScreen()));
              }),
        ],
      ),
    );
  }
}

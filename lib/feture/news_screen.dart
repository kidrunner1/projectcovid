import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/appointment/form_appoints.dart';
import 'package:tracker_covid_v1/screen/appointment/showdata_appoints.dart';
import 'package:tracker_covid_v1/screen/callphone.dart';
import 'package:tracker_covid_v1/screen/check_covid/details_chek.dart';
import 'package:tracker_covid_v1/screen/covid_data_screen.dart';
import 'package:tracker_covid_v1/screen/evaluate_symptom/showdata_symptom.dart';
import 'package:tracker_covid_v1/screen/track_covid.dart';
import 'package:tracker_covid_v1/screen/vaccine/show_vaccine.dart';

class NewsScreens extends StatefulWidget {
  const NewsScreens({Key? key}) : super(key: key);

  @override
  State<NewsScreens> createState() => _NewsScreensState();
}

class _NewsScreensState extends State<NewsScreens> {
  int _currentPage = 0;
  List<String> _imageUrls = [
    'https://www.nstda.or.th/home/wp-content/uploads/2020/03/Banner-Web-NSTDA_Corona_613-x-345-px.jpg',
    'https://seanphudat.chachoengsao.police.go.th/SPDPOLICE/wp-content/uploads/2023/01/%E0%B8%A3%E0%B8%B0%E0%B8%A7%E0%B8%B1%E0%B8%87-%E0%B8%AB%E0%B8%A5%E0%B8%AD%E0%B8%81%E0%B8%88%E0%B8%B1%E0%B8%94%E0%B8%AB%E0%B8%B2%E0%B8%87%E0%B8%B2%E0%B8%99%E0%B8%95%E0%B9%88%E0%B8%B2%E0%B8%87%E0%B8%9B%E0%B8%A3%E0%B8%B0%E0%B9%80%E0%B8%97%E0%B8%A8-%E0%B8%AB%E0%B8%A5%E0%B8%B1%E0%B8%87%E0%B8%97%E0%B8%B1%E0%B9%88%E0%B8%A7%E0%B9%82%E0%B8%A5%E0%B8%81-%E0%B9%80%E0%B8%9B%E0%B8%B4%E0%B8%94%E0%B8%9B%E0%B8%A3%E0%B8%B0%E0%B9%80%E0%B8%97%E0%B8%A8-%E0%B8%9B%E0%B8%A5%E0%B8%94%E0%B8%A5%E0%B9%87%E0%B8%AD%E0%B8%81%E0%B9%82%E0%B8%84%E0%B8%A7%E0%B8%B4%E0%B8%94-19_Website.png',
    'https://vichaivej-nongkhaem.com/wp-content/uploads/2021/08/%E0%B8%A3%E0%B8%B9%E0%B9%89%E0%B8%88%E0%B8%B1%E0%B8%81%E0%B8%A5%E0%B8%AD%E0%B8%87%E0%B9%82%E0%B8%84%E0%B8%A7%E0%B8%B4%E0%B8%94-1024x538.jpg'
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
          color: Colors.red[50],
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
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
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
                        builder: (context) => showdata_symptom()));
              }),
          SizedBox(width: 12),
          _iconContainer(
              iconData: Icons.trending_up,
              label: 'สถิติผู้ติดเชื้อในทั่วโลก',
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowData_VaccineLocation()));
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
                    MaterialPageRoute(builder: (context) => CallPhone()));
              }),
          SizedBox(width: 12),
          _iconContainer(
              iconData: FontAwesomeIcons.pills,
              label: 'ติดต่อเข้ารับยา',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormAppointments()));
              }),
          SizedBox(width: 12),
          _iconContainer(
              iconData: Icons.assignment,
              label: 'บันทึกผลตรวจประจำวัน',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsCheckScreen()));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Showdata_appoints()));
              }),
          SizedBox(width: 12),
          _iconContainer(
              iconData: FontAwesomeIcons.locationDot,
              label: 'สถิติผู้ติดเชื้อแต่ละจังหวัด',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CovidDataScreen()));
              }),
        ],
      ),
    );
  }
}

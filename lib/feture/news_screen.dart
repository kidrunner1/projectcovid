// ignore_for_file: avoid_unnecessary_containers
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/screen/call_page.dart';
import 'package:tracker_covid_v1/screen/covid_data_screen.dart';
import 'package:tracker_covid_v1/screen/record_daily.dart';
import 'package:tracker_covid_v1/screen/track_covid.dart';

class NewsScreens extends StatefulWidget {
  const NewsScreens({Key? key}) : super(key: key);

  @override
  State<NewsScreens> createState() => _NewsScreensState();
}

class _NewsScreensState extends State<NewsScreens> {
  int _currentPage = 0;
  // ignore: prefer_final_fields
  List<String> _imageUrls = [
    "https://ecobnb.com/blog/app/uploads/sites/3/2020/01/nature.jpg",
    'https://w1.med.cmu.ac.th/family/wp-content/uploads/2020/09/Covid-19-scaled.jpg',
    'https://www.klonghaecity.go.th/files/com_networknews/2020-12_56ff228cf695781.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 190,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  //Autoplay
                  //autoPlay: true, // Enable auto-play
                  //autoPlayInterval: Duration(seconds: 3), // Set auto-play interval
                  //autoPlayAnimationDuration: Duration(
                  //  milliseconds: 800), // Set auto-pl ay animation duration
                  //autoPlayCurve: Curves.fastOutSlowIn, // Set auto-play curve
                ),
                items: _imageUrls.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_imageUrls.length, (index) {
                  return Container(
                    width: _currentPage == index ? 10.0 : 8.0,
                    height: _currentPage == index ? 10.0 : 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.red.shade700
                          : Colors.grey,
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 30,
              ),

              // ไอค่อนไปยังหน้าต่อไป
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SettingScreen();
                        }));
                      },
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.red.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                size: 30,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'ประเมินความเสี่ยง',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              )
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CovidTrackerScreen();
                        }));
                      },
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.red.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 30,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'จำนวนผู้ติดเชือ',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              )
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SettingScreen();
                        }));
                      },
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.red.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'นัดฉีดวัคซีน',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              //ไอค่อนไปยังหน้าต่อไป
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CallPage();
                          }));
                        },
                        child: Container(
                          width: 120,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.red.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 30,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'สายด่วน',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SettingScreen();
                          }));
                        },
                        child: Container(
                          width: 120,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.red.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 30,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'ติดต่อเข้ารับยา',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Memo();
                          }));
                        },
                        child: Container(
                          width: 120,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.red.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment,
                                  size: 30,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'บันทึกผลตรวจประจำวัน',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  textAlign: TextAlign.center,
                                )
                              ]),
                        ),
                      ),
                    ]),
              ),
              //ไอค่อนไปยังหน้าต่อไป
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CovidDataScreen();
                        }));
                      },
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.red.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                size: 30,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'การนัดของคุณ',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              )
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CovidDataScreen();
                        }));
                      },
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.red.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_location,
                                size: 30,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'ภายในจังหวัด',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              )
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SettingScreen();
                        }));
                      },
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.red.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'นัดฉีดวัคซีน',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// New custom widget for the icon containers
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
        color: Colors.red.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

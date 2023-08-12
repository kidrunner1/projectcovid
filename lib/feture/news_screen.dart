// ignore_for_file: avoid_unnecessary_containers

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tracker_covid_v1/feture/setting.dart';
import 'package:tracker_covid_v1/screen/call_page.dart';

import '../screen/syringe_page.dart';

class NewsScreens extends StatefulWidget {
  const NewsScreens({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
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
                      borderRadius: BorderRadius.circular(30.0),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'บ ริ ก า ร',
                  style: TextStyle(fontSize: 30, color: Colors.redAccent),
                ),
              ],
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
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
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
                              Icons.trending_up,
                              size: 30,
                              color: Colors.redAccent,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'จำนวนผู้ติดเชือ',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            )
                          ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SyringePage();
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
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
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
                                Icons.calendar_month,
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
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

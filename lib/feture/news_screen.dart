
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
    return Padding(
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
              autoPlay: true, // Enable auto-play
              autoPlayInterval: Duration(seconds: 3), // Set auto-play interval
              autoPlayAnimationDuration: Duration(
                  milliseconds: 800), // Set auto-play animation duration
              autoPlayCurve: Curves.fastOutSlowIn, // Set auto-play curve
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_imageUrls.length, (index) {
              return Container(
                width: _currentPage == index ? 10.0 : 8.0,
                height: _currentPage == index ? 10.0 : 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

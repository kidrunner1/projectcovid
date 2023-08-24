import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/feture/news_screen.dart';

import 'package:tracker_covid_v1/model/covid_data.dart';
import 'package:tracker_covid_v1/widget/covid_stats_widget.dart';
import '../services/covid_api.dart';

class CovidTrackerScreen extends StatefulWidget {
  @override
  _CovidTrackerScreenState createState() => _CovidTrackerScreenState();
}

class _CovidTrackerScreenState extends State<CovidTrackerScreen> {
  final CovidApiService _covidApiService = CovidApiService();
  late Future<CovidData> _thailandCovidData;
  late Future<CovidData> _worldCovidData;

  @override
  void initState() {
    super.initState();
    _thailandCovidData = _covidApiService.fetchCovidDataForThailand();
    _worldCovidData = _covidApiService.fetchCovidDataForWorld();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 97, 97),
      ),
      backgroundColor: Colors.red.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('ยืนยันตัวเลขผู้ติดเชื้อ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Covid-19',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('ในประเทศไทย',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FutureBuilder<CovidData>(
                  future: _thailandCovidData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error loading data');
                    } else {
                      final covidData = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'ผู้ติดเชื้อสะสม : ${covidData.cases}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: FutureBuilder<CovidData>(
                future: _thailandCovidData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading data');
                  } else {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CovidStatsWidget(
                              title: 'กำลังรักษา',
                              count: snapshot.data!.recovered,
                              color: Colors.amber,
                            ),
                            CovidStatsWidget(
                              title: 'หายแล้ว',
                              count: snapshot.data!.recovered,
                              color: Colors.green,
                            ),
                            CovidStatsWidget(
                              title: 'เสียชีวิต',
                              count: snapshot.data!.deaths,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

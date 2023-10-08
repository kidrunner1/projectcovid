import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/model/covid_data.dart';
import 'package:tracker_covid_v1/screen/main_page.dart';

import 'package:intl/intl.dart';
import 'package:tracker_covid_v1/services/covid_api_service.dart'; // For formatting numbers with commas

class CovidTrackerScreen extends StatefulWidget {
  @override
  _CovidTrackerScreenState createState() => _CovidTrackerScreenState();
}

class _CovidTrackerScreenState extends State<CovidTrackerScreen> {
  final CovidApiService _covidApiService = CovidApiService();
  late Future<CovidData>? _thailandCovidData;

  // ignore: unused_field
  late Future<CovidData>? _worldCovidData;
  late Future<List<CovidData>>? _top5CountriesCovidData;

  final Map<String, String> countryToCode = {
    'USA': 'us',
    'India': 'in',
    'Brazil': 'br',
    'France': 'fr',
    'Germany': 'de',
    // Add more countries as required.
  };

  @override
  void initState() {
    super.initState();
    _thailandCovidData = _covidApiService.fetchCovidDataForThailand();
    _worldCovidData = _covidApiService.fetchCovidDataForWorld();
    _top5CountriesCovidData = _covidApiService.fetchTop5CountriesByCases();
  }

  _initializeData() {
    setState(() {
      _thailandCovidData = _covidApiService.fetchCovidDataForThailand();
      _worldCovidData = _covidApiService.fetchCovidDataForWorld();
      _top5CountriesCovidData = _covidApiService.fetchTop5CountriesByCases();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final TextStyle headStyle = GoogleFonts.prompt(
      fontSize: width * 0.06,
      fontWeight: FontWeight.bold,
      color: Colors.red[300],
    );
    final TextStyle subHeadStyle = GoogleFonts.prompt(
      fontSize: width * 0.045,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
    final TextStyle dataStyle = GoogleFonts.prompt(
      fontSize: width * 0.04,
      color: Colors.white,
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.red[300],
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[50]!, Colors.red[50]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.red[300]),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                    },
                  ),
                ),
                Text(
                  'ข้อมูลสถิติผู้ติดเชื้อทั่วโลก',
                  textAlign: TextAlign.center,
                  style: headStyle,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildThailandDataCard(dataStyle, subHeadStyle),
                      const SizedBox(height: 20),
                      _buildWorldDataCard(dataStyle, subHeadStyle),
                      const SizedBox(height: 20),
                      _buildTop5CountriesCard(dataStyle, subHeadStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThailandDataCard(TextStyle dataStyle, TextStyle subHeadStyle) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<CovidData>(
          future: _thailandCovidData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Colors.red[300],
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error loading data for Thailand',
                style:
                    dataStyle.copyWith(color: Colors.redAccent, fontSize: 16),
                textAlign: TextAlign.center,
              );
            } else {
              final thailandData = snapshot.data!;
              int activeCases = thailandData.cases - thailandData.recovered;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'สถิติผู้ติดในประเทศไทย',
                    style: subHeadStyle.copyWith(
                      color: Colors.red[300],
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _simpleCovidStat('เคสทั้งหมด', thailandData.cases, dataStyle,
                      color: Colors.black),
                  const SizedBox(height: 10),
                  _simpleCovidStat('กำลังรักษา', activeCases, dataStyle,
                      color: Colors.amber),
                  const SizedBox(height: 10),
                  _simpleCovidStat('หายแล้ว', thailandData.recovered, dataStyle,
                      color: Colors.green),
                  const SizedBox(height: 10),
                  _simpleCovidStat('เสียชีวิต', thailandData.deaths, dataStyle,
                      color: Colors.red),
                  const SizedBox(height: 10),
                  // Add any other type of data here, following the same pattern
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _simpleCovidStat(String label, int value, TextStyle style,
      {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: style.copyWith(
              color: color?.withOpacity(0.7), fontWeight: FontWeight.normal),
        ),
        Text(
          '${NumberFormat("#,###").format(value)}',
          style: style.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildWorldDataCard(TextStyle dataStyle, TextStyle subHeadStyle) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<CovidData>(
          future: _worldCovidData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Colors.red[300],
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error loading global data',
                style:
                    dataStyle.copyWith(color: Colors.redAccent, fontSize: 16),
                textAlign: TextAlign.center,
              );
            } else {
              final worldData = snapshot.data!;
              int activeCases = worldData.cases - worldData.recovered;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'สถิติผู้ติดเชื้อทั่วโลก',
                    style: subHeadStyle.copyWith(
                      color: Colors.red[300],
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _simpleCovidStat('เคสทั้งหมด', worldData.cases, dataStyle,
                      color: Colors.black),
                  const SizedBox(height: 10),
                  _simpleCovidStat('กำลังรักษา', activeCases, dataStyle,
                      color: Colors.amber),
                  const SizedBox(height: 10),
                  _simpleCovidStat('หายแล้ว', worldData.recovered, dataStyle,
                      color: Colors.green),
                  const SizedBox(height: 10),
                  _simpleCovidStat('เสียชีวิต', worldData.deaths, dataStyle,
                      color: Colors.red),
                  const SizedBox(height: 10),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTop5CountriesCard(TextStyle dataStyle, TextStyle subHeadStyle) {
    return Card(
      elevation: 5.0, // Added shadow for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(20.0), // Increased padding for a spacious feel
        child: FutureBuilder<List<CovidData>>(
          future: _top5CountriesCovidData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.deepPurple,
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error loading top 5 countries',
                style: dataStyle.copyWith(
                    color: Colors.redAccent), // Make error noticeable
              );
            } else {
              final top5Data = snapshot.data!;
              return Column(
                children: List<Widget>.generate(top5Data.length, (index) {
                  final countryData = top5Data[index];
                  final countryCode = countryToCode[countryData.country] ?? '';
                  return Container(
                    margin: const EdgeInsets.only(
                        bottom: 12.0), // Added space between items
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 15.0), // Padding inside each list item
                    decoration: BoxDecoration(
                      // New decoration
                      color: index % 2 == 0
                          ? Colors.red[200]
                          : Colors.red[200], // Zebra-striping
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero, // Adjusted padding
                      leading: countryCode.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: AssetImage(
                                'icons/flags/png/$countryCode.png',
                                package: 'country_icons',
                              ),
                              radius: 25, // Increased radius
                            )
                          : null,
                      title: Text(countryData.country,
                          style: subHeadStyle.copyWith(
                              color: Colors.white)), // Adjusted color
                      subtitle: Text(
                        'จำนวนผู้ป่วย: ${NumberFormat("#,###").format(countryData.cases)}',
                        style: dataStyle,
                      ),
                    ),
                  );
                }),
              );
            }
          },
        ),
      ),
    );
  }
}

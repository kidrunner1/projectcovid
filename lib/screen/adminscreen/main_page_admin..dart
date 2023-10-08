import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Appointment/get_appoints.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Datadaily/getdata_dailys_admin.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Envaluate/get_envaluate_admin.dart';
import 'package:tracker_covid_v1/screen/adminscreen/vaccine/getdata_vaccine_admin.dart';

class MainPageAdmin extends StatefulWidget {
  const MainPageAdmin({super.key});

  @override
  State<MainPageAdmin> createState() => _MainPageAdminState();
}

class _MainPageAdminState extends State<MainPageAdmin> {
  Future<int> _getResultsCountForToday() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(microseconds: 1));

    // Count from checkResults
    QuerySnapshot checkResultsSnapshot;

    try {
      checkResultsSnapshot = await FirebaseFirestore.instance
          .collection('checkResults')
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThanOrEqualTo: endOfDay)
          .get();
    } catch (e) {
      print("Error fetching data: $e");
      return 0;
    }

    return checkResultsSnapshot.docs.length;
  }

  Widget _buildResultsCountForToday() {
    return FutureBuilder<int>(
      future: _getResultsCountForToday(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text(
            'ผู้ใช้งานในวันนี้: ${snapshot.data ?? 0}',
            style:
                GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold),
          );
        }
      },
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
        width: 140,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 60,
              color: Colors.brown[800],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.prompt(fontSize: 16, color: Colors.black),
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
      //backgroundColor: Colors.pink.shade50,
      body: Column(
        children: [
          SizedBox(
              height:
                  40), // <-- Added this SizedBox for some spacing from the top
          Expanded(
            flex: 2,
            child: _floatingUserCountDisplay(),
          ),
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavigationRow1(),
                const SizedBox(height: 25),
                _buildNavigationRow2(),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingUserCountDisplay() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueAccent[100]!, Colors.purpleAccent[200]!],
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.white60,
                  highlightColor: Colors.white,
                  child: const Icon(
                    Icons.people,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 10),
                Shimmer.fromColors(
                  baseColor: Colors.white60,
                  highlightColor: Colors.white,
                  child: _buildResultsCountForToday(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationRow1() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _iconContainer(
          iconData: Icons.assignment_outlined,
          label: 'รายงานประเมินความเสี่ยง',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GetEnvaluateAdminScreen()));
          }),
      const SizedBox(width: 25),
      _iconContainer(
        iconData: FontAwesomeIcons.thermometerThreeQuarters,
        label: 'รายละเอียดผู้ป่วยประจำวัน',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GetDataDailysAdminScreen(),
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildNavigationRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _iconContainer(
            iconData: FontAwesomeIcons.pills,
            label: 'รายงานนัดรับยา',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GetDataAppointsAdmin()));
            }),
        const SizedBox(width: 25),
        _iconContainer(
            iconData: FontAwesomeIcons.syringe,
            label: 'การรับวัคซีน',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GetDataVaccineAdmin()));
            }),
      ],
    );
  }
}

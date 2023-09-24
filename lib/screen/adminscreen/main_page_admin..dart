import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/screen/adminscreen/getdata_dailys_admin.dart';
import 'package:tracker_covid_v1/screen/adminscreen/details_medicin.dart';
import 'package:tracker_covid_v1/screen/adminscreen/dtails_evaluate_admin.dart';
import 'package:tracker_covid_v1/screen/appointment/form_appoints.dart';
import 'package:tracker_covid_v1/screen/vaccine/screen_vaccine.dart';

class MainPageAdmin extends StatefulWidget {
  const MainPageAdmin({super.key});

  @override
  State<MainPageAdmin> createState() => _MainPageAdminState();
}

class _MainPageAdminState extends State<MainPageAdmin> {
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
              const SizedBox(height: 10),
              const SizedBox(height: 25),
              _buildNavigationRow1(),
              const SizedBox(height: 25),
              _buildNavigationRow2(),
              const SizedBox(height: 25),
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
          const SizedBox(width: 12),
          _iconContainer(
              iconData: Icons.assignment_outlined,
              label: 'รายงานประเมินความเสี่ยง',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DetailsEnvaluateAdminScreen()));
              }),
          const SizedBox(width: 12),
          _iconContainer(
              iconData: FontAwesomeIcons.syringe,
              label: 'นัดฉีดวัคซีน',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScreenVaccine()));
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
          const SizedBox(width: 12),
          _iconContainer(
              iconData: FontAwesomeIcons.pills,
              label: 'รายละเอียดติดต่อเข้ารับยา',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MedicinAdminScreen()));
              }),
          const SizedBox(width: 12),
          _iconContainer(
              iconData: Icons.assignment,
              label: 'รายละเอียดบันทึกผลตรวจประจำวัน',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const GetdataDailysAdminScreen()));
              }),
        ],
      ),
    );
  }

  Widget _buildNavigationRow3() {
    return _buildNavigationRow(
      const Row(mainAxisSize: MainAxisSize.min, children: []),
    );
  }
}

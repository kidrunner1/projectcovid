import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CovidDataScreen extends StatefulWidget {
  @override
  _CovidDataScreenState createState() => _CovidDataScreenState();
}

class _CovidDataScreenState extends State<CovidDataScreen> {
  String? selectedProvince;
  List<dynamic>? covidData;
  List<dynamic>? filteredData;

  @override
  void initState() {
    super.initState();
    fetchCovidDataByProvince().then((data) {
      setState(() {
        covidData = data;
        filteredData = data;
      });
    });
  }

  Future<List<dynamic>?> fetchCovidDataByProvince() async {
    var url = Uri.parse(
        'https://covid19.ddc.moph.go.th/api/Cases/today-cases-by-provinces');
    var response = await http.get(url);

    // ignore: unnecessary_null_comparison
    if (response.statusCode == 200 && response.body != null) {
      return json.decode(response.body) as List<dynamic>?;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  void _searchProvince(String query) {
    final filtered = covidData!.where((province) {
      final provinceName = province['province'].toString().toLowerCase();
      return provinceName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredData = filtered;
    });
  }

  void _showProvinceDetails(dynamic provinceData) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 5,
          backgroundColor: Colors.transparent,
          child: _buildContent(provinceData),
        );
      },
    );
  }

  Widget _buildContent(dynamic provinceData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // Changed from grey to white
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12, // Lightened the shadow
            offset: Offset(0, 10),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              provinceData['province'] ?? 'Unknown Province',
              style: GoogleFonts.prompt(
                fontSize: 24,
                color: Colors.red[300],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
          _infoRow(Icons.healing, 'เคสผู้ป่วยใหม่:', provinceData['new_case']),
          const SizedBox(height: 15),
          _infoRow(FontAwesomeIcons.person, 'เคสผู้ป่วยทั้งหมด:',
              provinceData['total_case']),
          const SizedBox(height: 15),
          _infoRow(Icons.local_hospital_outlined, 'เสียชีวิตทั้งหมด:',
              provinceData['total_death']),
          const SizedBox(height: 25),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
              ),
              child: Text(
                'ปิด',
                style: GoogleFonts.prompt(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, dynamic data) {
    return Row(
      children: [
        Icon(icon, color: Colors.redAccent, size: 28.0),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            '$label ${data ?? 'Data Not Available'}',
            style: GoogleFonts.prompt(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Covid-19 Data',
          style: GoogleFonts.prompt(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[300],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white, // Changed from grey to white
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12, // Lightened the shadow
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                style: GoogleFonts.prompt(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'ค้นหาจังหวัด ...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.redAccent),
                  border: InputBorder.none,
                ),
                onChanged: _searchProvince,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await fetchCovidDataByProvince().then((data) {
                    setState(() {
                      covidData = data;
                      filteredData = data;
                    });
                  });
                },
                color:
                    Colors.redAccent, // Adjusted color of the RefreshIndicator
                child: (filteredData == null)
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors
                              .redAccent), // Adjusted color of the CircularProgressIndicator
                        ),
                      )
                    : (filteredData!.isEmpty)
                        ? Center(
                            child: Text(
                              'No data available.',
                              style: GoogleFonts.prompt(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredData!.length,
                            itemBuilder: (context, index) {
                              final provinceData = filteredData![index];
                              return Card(
                                color:
                                    Colors.white, // Changed card color to white
                                elevation: 5, // Added elevation for depth
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: BorderSide(
                                    color: Colors.redAccent.withOpacity(0.2),
                                  ), // subtle red border
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 5.0),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  title: Text(
                                    provinceData['province'],
                                    style: GoogleFonts.prompt(
                                      fontSize: 18,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      color: Colors.redAccent),
                                  onTap: () {
                                    _showProvinceDetails(provinceData);
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

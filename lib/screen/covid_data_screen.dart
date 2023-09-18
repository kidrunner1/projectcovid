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
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            provinceData['province'] ?? 'Unknown Province',
            style: GoogleFonts.robotoSlab(
              fontSize: 22,
              color: Colors.deepPurpleAccent,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.healing,
                      color: Colors.blueAccent, size: 24.0),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'เคสผู้ป่วยใหม่: ${provinceData['new_case'] ?? 'Data Not Available'}',
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(FontAwesomeIcons.person,
                      color: Colors.orangeAccent, size: 24.0),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'เคสผู้ป่วยทั้งหมด: ${provinceData['total_case'] ?? 'Data Not Available'}',
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.local_hospital_outlined,
                      color: Colors.redAccent, size: 24.0),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'เสียชีวิตทั้งหมด: ${provinceData['total_death'] ?? 'Data Not Available'}',
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              // ignore: sort_child_properties_last
              child: Text(
                'Close',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.deepPurpleAccent,
                  fontSize: 16,
                ),
              ),
              style: TextButton.styleFrom(
                // ignore: prefer_const_constructors
                foregroundColor: Colors.deepPurpleAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Covid-19 Data by Province',
          style: GoogleFonts.robotoCondensed(fontSize: 22, color: Colors.white),
        ),
        backgroundColor: Colors.red[300],
      ),
      body: Container(
        color: Colors.pink[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  style: GoogleFonts.roboto(),
                  decoration: InputDecoration(
                    hintText: 'ค้นหาจังหวัด . . .',
                    prefixIcon: Icon(Icons.search, color: Colors.red[300]),
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
                  child: (filteredData == null)
                      ? const Center(child: CircularProgressIndicator())
                      : (filteredData!.isEmpty)
                          ? const Center(
                              child: Text(
                              'No data available for the selected province.',
                              style: TextStyle(color: Colors.grey),
                            ))
                          : ListView.builder(
                              itemCount: filteredData!.length,
                              itemBuilder: (context, index) {
                                final provinceData = filteredData![index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 5.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 5.0),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    title: Text(
                                      provinceData['province'],
                                      style: GoogleFonts.prompt(
                                          fontSize: 18, color: Colors.red[300]),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios,
                                        size: 14, color: Colors.red[300]),
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
      ),
    );
  }
}
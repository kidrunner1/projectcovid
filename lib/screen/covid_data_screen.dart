import 'package:flutter/material.dart';
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
          title: Text(provinceData['province'] ?? 'Unknown Province',
              style: TextStyle()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'เคสผู้ป่วยใหม่: ${provinceData['new_case'] ?? 'Data Not Available'}',
                  style: TextStyle()),
              Text(
                  'เคสผู้ป่วยทั้งหมด: ${provinceData['total_case'] ?? 'Data Not Available'}',
                  style: TextStyle()),
              Text(
                  'เสียชีวิตทั้งหมด: ${provinceData['total_death'] ?? 'Data Not Available'}',
                  style: TextStyle()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.amber)),
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
        title:
            Text('Covid-19 Data by Province', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.red.shade300,
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        color: Colors.pink.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'ค้นหาจังหวัด . . .',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                onChanged: _searchProvince,
              ),
              const SizedBox(height: 16.0),
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
                        ? const Center(child: Text('Fetching data...'))
                        : (filteredData!.isEmpty)
                            ? const Center(
                                child: Text(
                                    'No data available for the selected province.'))
                            : ListView.builder(
                                itemCount: filteredData!.length,
                                itemBuilder: (context, index) {
                                  final provinceData = filteredData![index];
                                  return Card(
                                    elevation: 3.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      title: Text(provinceData['province'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        _showProvinceDetails(provinceData);
                                      },
                                    ),
                                  );
                                },
                              )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

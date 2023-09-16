import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/covid_data.dart';

class CovidApiService {
  Future<CovidData> fetchCovidDataForThailand() async {
    final response = await http
        .get(Uri.parse('https://disease.sh/v3/covid-19/countries/thailand'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CovidData(
        cases: data['cases'],
        recovered: data['recovered'],
        deaths: data['deaths'],
        country: '',
      );
    } else {
      throw Exception('Failed to load COVID-19 data for Thailand');
    }
  }

  Future<CovidData> fetchCovidDataForWorld() async {
    final response =
        await http.get(Uri.parse('https://disease.sh/v3/covid-19/all'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CovidData(
        cases: data['cases'],
        recovered: data['recovered'],
        deaths: data['deaths'],
        country: '',
      );
    } else {
      throw Exception('Failed to load global COVID-19 data');
    }
  }

  Future<List<CovidData>> fetchTop5CountriesByCases() async {
    final response = await http
        .get(Uri.parse('https://disease.sh/v3/covid-19/countries?sort=cases'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Convert the first 5 entries to CovidData and return them.
      return data.take(5).map((e) => CovidData.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load COVID-19 data for top countries');
    }
  }
}

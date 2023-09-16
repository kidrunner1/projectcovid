class CovidData {
  final String country;
  final int cases;
  final int recovered;
  final int deaths;

  CovidData(
      {required this.country,
      required this.cases,
      required this.recovered,
      required this.deaths});

  factory CovidData.fromMap(Map<String, dynamic> map) {
    return CovidData(
      country: map['country'],
      cases: map['cases'],
      recovered: map['recovered'],
      deaths: map['deaths'],
    );
  }
}

class CountryCovidData {
  final String country;
  final int cases;
  final int recovered;
  final int deaths;
  final String countryFlagCode; // Add this property

  CountryCovidData({
    required this.country,
    required this.cases,
    required this.recovered,
    required this.deaths,
    required this.countryFlagCode,
  });
}

class ProvinceData {
  final String provinceName;
  final int totalCases;

  ProvinceData({required this.provinceName, required this.totalCases});
}

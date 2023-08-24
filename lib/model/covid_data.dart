class CovidData {
  final int cases;
  final int recovered;
  final int deaths;

  CovidData({
    required this.cases,
    required this.recovered,
    required this.deaths,
  });
}

class CountryCovidData {
  final String country;
  final int cases;
  final int recovered;
  final int deaths;
  final String flagUrl;

  CountryCovidData({
    required this.country,
    required this.cases,
    required this.recovered,
    required this.deaths,
    required this.flagUrl,
  });
}

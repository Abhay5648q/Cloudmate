import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloudmate/models/forecast_model.dart';

class ForcastService {
  final String apiKey = '1fed5d5ba26c56c64d2a356d499d3b0f';

  Future<List<ForecastModel>> fetchRawForecast(String cityName) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> forecastList = data['list'];

      return forecastList
          .map((item) => ForecastModel.fromjson(item))
          .toList();
    } else {
      throw Exception('Failed to load forecast');
    }
  }

  Future<List<ForecastModel>> fetchFiveDayMiddayForecast(String cityName) async {
    final forecasts = await fetchRawForecast(cityName);

    final Map<String, ForecastModel> dailyMap = {};

    for (var forecast in forecasts) {
      final date = forecast.date;

      if (date.hour == 12) {
        final key = "${date.year}-${date.month}-${date.day}";
        if (!dailyMap.containsKey(key)) {
          dailyMap[key] = forecast;
        }
      }
    }

    final sortedForecasts = dailyMap.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return sortedForecasts;
  }

  
  Future<List<ForecastModel>> fetchThreeDayForecast(String cityName) async {
    final all = await fetchFiveDayMiddayForecast(cityName);
    return all.take(3).toList(); 
  }
}

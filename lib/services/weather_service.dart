import 'dart:convert';

import 'package:cloudmate/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "1fed5d5ba26c56c64d2a356d499d3b0f";

  Future<WeatherModel> fetchWeather(String cityName) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric",
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return WeatherModel.fromjson(jsonDecode(response.body) as Map<String,dynamic>);
    } else {
       throw Exception('Failed to load data');
    }
  }
}

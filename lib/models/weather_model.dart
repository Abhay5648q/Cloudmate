class WeatherModel {
  final String cityName;
  final String weathercondition;
  final double temp;
  final double minTemp;
  final double maxTemp;
  final int sunrise; // <-- add this
  final int sunset;
  final int humidity;
  final String weatherIcon;
  WeatherModel({
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.cityName,
    required this.weatherIcon,
    required this.humidity,
    required this.weathercondition,
    required this.sunrise,
    required this.sunset,
  });
  factory WeatherModel.fromjson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      weathercondition: json['weather'][0]['main'],
      temp: (json['main']['temp'] ?? 0.0),
      minTemp: (json['main']['temp_min'] ?? 0.0),
      maxTemp: (json['main']['temp_max'] ?? 0.0),
      humidity: json['main']['humidity'] ?? 0,
      weatherIcon: json['weather'][0]['icon'] ?? '',
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
  String get iconUrl => "https://openweathermap.org/img/wn/$weatherIcon@2x.png";
}

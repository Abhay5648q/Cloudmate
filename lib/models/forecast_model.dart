class ForecastModel {
  final double temp;
  final String icon;
  final String description;
  final String weekday;
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  
  ForecastModel({
    required this.temp,
    required this.icon,
    required this.description,
    required this.weekday,
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    
  });

  factory ForecastModel.fromjson(Map<String, dynamic> json) {
    final dtText = json['dt_txt'];
    final date = DateTime.parse(dtText);

    return ForecastModel(
      temp: (json['main']['temp'] as num).toDouble(),
      minTemp: (json['main']['temp_min'] as num).toDouble(),
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
      weekday: dtText,
      date: date,
       
    );
  }
}

import 'package:cloudmate/models/forecast_model.dart';
import 'package:cloudmate/services/forcast_service.dart';
import 'package:flutter/material.dart';

class DayForecast extends StatefulWidget {
  final String city;
  final String humidity;
  final int sunset;
  final int sunrise;
  const DayForecast({
    super.key,
    required this.city,
    required this.humidity,
    required this.sunset,
    required this.sunrise,
  });

  @override
  State<DayForecast> createState() => _DayForecastState();
}

class _DayForecastState extends State<DayForecast> {
  int currentIndex = 0;
  late Future<List<ForecastModel>> forecast;

  @override
  void initState() {
    super.initState();
   forecast = ForcastService().fetchFiveDayMiddayForecast(widget.city);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: forecast,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final forecast = snapshot.data!;
            if (forecast.isEmpty) {
              return const Center(child: Text("No forecast data available"));
            }
            return Dayfor(
              forecasts: forecast,
              city: widget.city,
              humidity: widget.humidity,
              sunrise: widget.sunrise,
              sunset: widget.sunset,
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}

class Dayfor extends StatelessWidget {
  final List<ForecastModel> forecasts;

  final String city;
  final String humidity;
  final int sunset;
  final int sunrise;
  const Dayfor({
    super.key,
    required this.forecasts,
    required this.city,
    required this.humidity,
    required this.sunset,
    required this.sunrise,
  });
  String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 47, 150, 194),
            Color.fromARGB(255, 35, 90, 200),
            Color(0xFF9D52AC),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            children: [
              Text(
                city,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'calibri',
                ),
              ),

              const SizedBox(height: 10),
              Text(
                'Humidity: $humidity%',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 68.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "5-day Forecast",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'calibri',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 140,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.white),

                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,

                          itemCount: forecasts.length,
                          itemBuilder: (context, index) {
                            final item = forecasts[index];
                            final iconUrl =
                                "https://openweathermap.org/img/wn/${item.icon}@2x.png";
                            final date = DateTime.parse(item.weekday);
                            final day =
                                [
                                  'Sun',
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                ][date.weekday % 7];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Material(
                                elevation: 8,

                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromARGB(255, 103, 98, 220),
                                        Color.fromARGB(255, 68, 121, 226),
                                        Color.fromARGB(255, 227, 149, 242),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "${item.temp.toStringAsFixed(0)}°C",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Image.network(
                                        iconUrl,
                                        width: 60,
                                        height: 50,
                                      ),
                                      Text(
                                        day.toLowerCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Material(
                borderRadius: BorderRadius.circular(25),
                elevation: 4,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 227, 149, 242),
                        Color.fromARGB(255, 68, 121, 226),
                        Color.fromARGB(255, 103, 98, 220),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Image.asset(
                              color: Colors.white,
                              height: 22,
                              width: 22,
                              "assets/images/hi.png",
                            ),
                            Text(
                              "AIR QUALITY",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "3-Low Health Risk",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 10,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 227, 149, 242),
                                Color.fromARGB(255, 68, 121, 226),
                                Color.fromARGB(255, 103, 98, 220),
                                Color.fromARGB(255, 34, 35, 36),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "See More",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 87, 136, 216),
                            Color.fromARGB(255, 142, 180, 196),
                          ], // pale blue to light sky
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade600,
                            offset: Offset(2, 2),
                            blurRadius: 18,
                          ),

                          BoxShadow(
                            color: const Color.fromARGB(255, 17, 11, 11),

                            blurRadius: 8,
                          ),
                        ],
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.wb_sunny_rounded,
                                  color: Colors.white,
                                ),
                                Text(
                                  "SUNRISE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              formatTime(sunrise),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Sunset: ${formatTime(sunset)}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 87, 136, 216),
                            Color.fromARGB(255, 142, 180, 196),
                          ], // pale blue to light sky
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade600,
                            offset: Offset(2, 2),
                            blurRadius: 18,
                          ),

                          BoxShadow(
                            color: const Color.fromARGB(255, 17, 11, 11),

                            blurRadius: 8,
                          ),
                        ],
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(Icons.grass_rounded, color: Colors.white),
                                Text(
                                  "UV INDEX",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "4",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Moderate",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

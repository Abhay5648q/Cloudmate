import 'package:cloudmate/models/forecast_model.dart';
import 'package:cloudmate/models/weather_model.dart';
import 'package:cloudmate/screens/day_forecast.dart';
import 'package:cloudmate/services/forcast_service.dart';
import 'package:cloudmate/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   Future<WeatherModel> ?weather;
  late Future<List<ForecastModel>> ?forecast;
  String selectedCity = "Khatima";
  @override
  void initState() {
    super.initState();
    fetchWeatherForCity(selectedCity);
  }

  void fetchWeatherForCity(String city) async {
    try {
      final weatherData = await WeatherService().fetchWeather(city);
      final forecastData = await ForcastService().fetchThreeDayForecast(city);

      setState(() {
        selectedCity = city;
        weather = Future.value(weatherData);
        forecast = Future.value(forecastData);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid city name."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  String getDayLabel(DateTime forecastDate) {
    final now = DateTime.now();
    final difference =
        forecastDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (difference == 0) return "Today";
    if (difference == 1) return "Tomorrow";
    return DateFormat('EEE').format(forecastDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: weather == null
    ? Center(child: CircularProgressIndicator(
      color: Colors.black,
    ))
    : FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final weather = snapshot.data!;

            return Stack(
              children: [
                Container(
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
                  child: Column(
                    children: [
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    TextEditingController cityController =
                                        TextEditingController();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          backgroundColor: Color(0xFF222831),
                                          title: Text(
                                            "Enter City Name",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          content: TextField(
                                            controller: cityController,
                                            cursorColor: Colors.white,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "e.g. Khatima",
                                              hintStyle: TextStyle(
                                                color: Colors.white60,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white30,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white70,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              filled: true,
                                              fillColor: Color(0xFF393E46),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black87,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                String newCity =
                                                    cityController.text.trim();
                                                if (newCity.isNotEmpty) {
                                                  fetchWeatherForCity(newCity);
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Show Weather"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),

                                Text(
                                  weather.cityName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Image.network(
                        fit: BoxFit.contain,
                        weather.iconUrl,
                        width: 170,
                        height: 150,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weather.temp.toString(),
                            style: TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "°C",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weather.weathercondition,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${weather.minTemp}°C / ${weather.maxTemp}°C",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                            height: 25,
                            width: 77,
                            decoration: BoxDecoration(
                              color: Colors.lime[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Image.asset("assets/images/leaf.png"),
                                Text(
                                  "AQI",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  weather.humidity.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 3,
                  child: FutureBuilder<List<ForecastModel>>(
                    future: forecast,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error loading forecast");
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text("No forecast data");
                      }

                      final forecastData = snapshot.data!;

                      return Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(18),
                        child: GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DayForecast(
                                        city: weather.cityName,
                                        humidity: weather.humidity.toString(),
                                        sunset: weather.sunset,
                                        sunrise: weather.sunrise,
                                      ),
                                ),
                              ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  Color(0xFF9D52AC),
                                  Color.fromARGB(255, 35, 90, 200),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "5-day forecast",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "More details",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        forecastData.length,
                                        (index) {
                                          final forecastItem =
                                              forecastData[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 5,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.network(
                                                  "https://openweathermap.org/img/wn/${forecastItem.icon}@2x.png",
                                                  width: 35,
                                                  height: 45,
                                                ),
                                                SizedBox(width: 8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getDayLabel(
                                                        forecastItem.date,
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      toBeginningOfSentenceCase(
                                                            forecastItem
                                                                .description,
                                                          ) ??
                                                          "",
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    /// Right Column (min/max temp)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: List.generate(
                                        forecastData.length,
                                        (index) {
                                          final item = forecastData[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 30,
                                            ),
                                            child: Text(
                                              "${item.minTemp.round()}° / ${item.maxTemp.round()}°",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                /// Button
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 6,
                                      minimumSize: Size(280, 45),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          transitionDuration: Duration(
                                            milliseconds: 500,
                                          ),
                                          pageBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                              ) => DayForecast(
                                                city: weather.cityName,
                                                humidity:
                                                    weather.humidity.toString(),
                                                sunrise: weather.sunrise,
                                                sunset: weather.sunset,
                                              ),
                                          transitionsBuilder: (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "5-day forecast",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
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
              ],
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weathering/additional_info_widget.dart';
import 'package:weathering/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;
import 'package:weathering/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = 'Lucknow';
    dynamic res = "";
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );
      final dynamic data = jsonDecode(response.body);
      res = data;
      String statusCode = data['cod'];
      if (statusCode != '200') {
        throw 'An unexpected error occured : Status code $statusCode';
      }
    } catch (e) {
      throw e.toString();
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weathering"),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //TODO : implement onPressed
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData  = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Icon(Icons.cloud, size: 64),
                              const SizedBox(height: 16),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // weather forecast cards
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForecastCard(
                        time: '00:00',
                        icon: Icons.cloud,
                        temperature: '30.2',
                      ),
                      HourlyForecastCard(
                        time: '03:00',
                        icon: Icons.sunny,
                        temperature: '35.2',
                      ),
                      HourlyForecastCard(
                        time: '06:00',
                        icon: Icons.water_drop,
                        temperature: '29.5',
                      ),
                      HourlyForecastCard(
                        time: '09:00',
                        icon: Icons.thunderstorm,
                        temperature: '27.6',
                      ),
                      HourlyForecastCard(
                        time: '12:00',
                        icon: Icons.snowing,
                        temperature: '-4.5',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // additional information\
                const Text(
                  "More Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoWidget(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '91',
                    ),
                    AdditionalInfoWidget(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '21',
                    ),
                    AdditionalInfoWidget(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '1006',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

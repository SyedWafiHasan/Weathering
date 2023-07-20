import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weathering/additional_info_widget.dart';
import 'package:weathering/get_icon.dart';
import 'package:weathering/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;
import 'package:weathering/secrets.dart';
import 'package:basic_utils/basic_utils.dart';

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
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentDescription = currentWeatherData['weather'][0]['description'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

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
                              Icon(getIcon(currentSky), size: 64),
                              const SizedBox(height: 16),
                              Text(
                                StringUtils.capitalize(currentDescription, allWords: true),
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
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 5; i++)
                //         HourlyForecastCard(
                //           time: data['list'][i + 1]['dt_txt'].toString().split(" ")[1],
                //           icon: data['list'][i + 1]['weather'][0]['main'] == 'Clouds' || data['list'][i + 1]['weather'][0]['main'] ==
                //                   'Rain' ? Icons.cloud : Icons.sunny,
                //           temperature: data['list'][i + 1]['main']['temp'].toString(),
                //         ),

                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemperature =
                          hourlyForecast['main']['temp'].toString();
                      return HourlyForecastCard(
                        time: hourlyForecast['dt_txt'].toString(),
                        icon: getIcon(hourlySky),
                        temperature: hourlyTemperature,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // additional information\
                const Text(
                  "More Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoWidget(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoWidget(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoWidget(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
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

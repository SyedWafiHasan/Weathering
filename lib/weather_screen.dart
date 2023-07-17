import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weathering/additional_info_widget.dart';
import 'package:weathering/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;
import 'package:weathering/secrets.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  Future getCurrentWeather() async {
    String cityName = 'Lucknow';
    final result = await http.get(
      Uri.parse(
        'https://http://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$openWeatherAPIKey',
      ),
    );
    print(result.body);
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
      body: Padding(
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
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '30 °C',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(Icons.cloud, size: 64),
                          SizedBox(height: 16),
                          Text(
                            'Rain',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Hourly Forecast",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weathering/weather_screen.dart';

void main() {
  runApp(const Weathering());
}

class Weathering extends StatelessWidget {
  const Weathering({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WeatherScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}
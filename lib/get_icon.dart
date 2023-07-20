import 'package:flutter/material.dart';

IconData result = Icons.dehaze;
IconData getIcon(String weather) {
  if (weather == 'Thunderstorm') result = Icons.cloud;
  if (weather == 'Drizzle') result = Icons.cloud;
  if (weather == 'Rain') result = Icons.cloud;
  if (weather == 'Snow') result = Icons.snowing;
  if (weather == 'Clear') result = Icons.sunny;
  if (weather == 'Clouds') result = Icons.cloud;
  if (weather == 'Tornado') result = Icons.tornado;
  return result;
}

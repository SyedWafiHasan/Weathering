import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            Text(
              '03:00',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Icon(Icons.cloud, size: 32),
            SizedBox(height: 8),
            Text('320.44'),
          ],
        ),
      ),
    );
  }
}

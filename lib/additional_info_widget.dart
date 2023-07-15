import 'package:flutter/material.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInfoWidget({
    super.key, 
    required this.icon, 
    required this.label, 
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

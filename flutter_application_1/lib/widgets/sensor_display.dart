import 'package:flutter/material.dart';

class SensorDisplay extends StatelessWidget {
  const SensorDisplay({super.key, required this.label, required this.value});

  final String label;
  final List<String>? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('$label: $value'),
        ],
      ),
    );
  }
}

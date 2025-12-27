import 'package:flutter/material.dart';

class TimeText extends StatelessWidget {
  final String time;

  const TimeText({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: const TextStyle(
        fontSize: 11,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

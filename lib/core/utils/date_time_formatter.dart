import 'package:flutter/material.dart';

String formatChatTime(BuildContext context, DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inMinutes < 1) {
    return 'Just now';
  }

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  }

  if (difference.inHours < 24 &&
      now.day == time.day &&
      now.month == time.month &&
      now.year == time.year) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(time),
      alwaysUse24HourFormat: false,
    );
  }

  if (difference.inDays == 1) {
    return 'Yesterday';
  }

  return '${time.day}/${time.month}/${time.year}';
}

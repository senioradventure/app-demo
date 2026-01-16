import 'package:flutter/material.dart';

String formatChatTime(BuildContext context, DateTime? time) {
  if (time == null) return '';
  
  final localTime = time.toLocal();
  final now = DateTime.now();
  final difference = now.difference(localTime);

  if (difference.inSeconds < 30) {
    return 'Just now';
  }

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  }

  // Today
  if (now.year == localTime.year && now.month == localTime.month && now.day == localTime.day) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(localTime),
      alwaysUse24HourFormat: false,
    );
  }

  // Yesterday
  final yesterday = now.subtract(const Duration(days: 1));
  if (yesterday.year == localTime.year && yesterday.month == localTime.month && yesterday.day == localTime.day) {
    return 'Yesterday';
  }

  // Last 7 days
  if (difference.inDays < 7) {
    final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekDays[localTime.weekday - 1];
  }

  return '${localTime.day}/${localTime.month}/${localTime.year}';
}

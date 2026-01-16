import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class TimeUtils {
  static String formatTimeString(String rawTime) {
    try {
      if (rawTime.isEmpty) return '';
      String utcTime = rawTime;
      if (!rawTime.endsWith('Z') && !rawTime.contains('+')) {
        utcTime = '${rawTime}Z';
      }

      DateTime dateTime = DateTime.parse(utcTime).toLocal();
      debugPrint('🕒 TimeUtils: raw="$rawTime" -> utc="$utcTime" -> local="$dateTime"');
      return DateFormat('h:mm a').format(dateTime); 
    } catch (e) {
      debugPrint('Error parsing time: $e');
      return rawTime;
    }
  }
}
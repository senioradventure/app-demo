import 'package:intl/intl.dart';

class TimeUtils {
  static String formatTimeString(String rawTime) {
    try {

      DateTime dateTime = DateTime.parse(rawTime).toLocal();

      return DateFormat('h:mm a').format(dateTime); 
    } catch (e) {

      return rawTime;
    }
  }
}
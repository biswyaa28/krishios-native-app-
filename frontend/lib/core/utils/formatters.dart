import 'package:intl/intl.dart';

class Formatters {
  static String temperature(double temp) => '${temp.round()}°C';
  static String humidity(int humidity) => '$humidity%';
  static String windSpeed(double speed) => '${speed.round()} km/h';
  static String date(DateTime date) => DateFormat('MMM d, y').format(date);
  static String time(DateTime date) => DateFormat('h:mm a').format(date);
  static String dateTime(DateTime date) => DateFormat('MMM d, y • h:mm a').format(date);
  static String relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return Formatters.date(date);
  }
}

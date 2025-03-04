import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Future<void> clearSessions() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('authToken');
}

String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) return "N/A";
  return DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
}

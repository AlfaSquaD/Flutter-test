import 'package:intl/intl.dart';

class Date {
  static DateTime? dateTime;
  static DateFormat formatter = DateFormat('yyyy-MM-dd');
  static bool initialized = false;
  static void init() {
    dateTime = DateTime.now();
    initialized = true;
  }

  static String getDateString() {
    if (!initialized) init();
    return formatter.format(dateTime!);
  }
}

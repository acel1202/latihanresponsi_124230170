import 'package:intl/intl.dart';

String formatDate(String raw) {
  try {
    final date = DateTime.parse(raw);
    return DateFormat("MMMM dd, yyyy – HH:mm").format(date);
  } catch (e) {
    return raw;
  }
}

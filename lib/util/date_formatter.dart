import 'package:intl/intl.dart';

String dateFormatted(int d) {
  var date = DateTime.fromMillisecondsSinceEpoch(d*1000);

  var formatter = new DateFormat("MMM d");
  String formatted = formatter.format(date);

  return formatted;
}

String timeFormatted(int d) {
  var time = DateTime.fromMillisecondsSinceEpoch(d*1000);

  var formatter = new DateFormat.jm();
  String formatted = formatter.format(time);

  return formatted;
}
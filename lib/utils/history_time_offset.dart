String historyTimeOffset(DateTime t) {
  var now = DateTime.now();
  if (t.year == now.year && t.month == now.month && t.day == now.day) {
    return '今天';
  }

  String day = t.day < 10 ? '0${t.day}' : '${t.day}';
  String hour = t.hour < 10 ? '0${t.hour}' : '${t.hour}';
  String minute = t.minute < 10 ? '0${t.minute}' : '${t.minute}';
  return '${t.year}-${t.month}-$day $hour:$minute';
}

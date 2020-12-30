String historyTimeOffset(DateTime t) {
  var now = DateTime.now();
  if (t.year == now.year && t.month == now.month && t.day == now.day) {
    return '今天';
  }

  String day = '${t.day}'.padLeft(2, '0');
  String hour = '${t.hour}'.padLeft(2, '0');
  String minute = '${t.minute}'.padLeft(2, '0');
  return '${t.year}-${t.month}-$day $hour:$minute';
}

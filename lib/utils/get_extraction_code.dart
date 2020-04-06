/// 从字符串中获取百度网盘提取码
/// 没获取到返回原字符串
String getExtractionCode(String text) {
  if (text.length < 4) return text;
  var r = RegExp(r'(?<=:)[a-zA-Z0-9]{4}').stringMatch(text);
  if (r != null) return r;
  return text;
}

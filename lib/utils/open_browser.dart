import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

/// 打开浏览器
Future<void> openBrowser(String url, [BuildContext context]) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    final msg = '无法打开: $url';
    if (context != null) {
      Toast.show(msg, context);
    } else {
      print(msg);
    }
  }
}

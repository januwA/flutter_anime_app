import 'package:url_launcher/url_launcher.dart';

/// 打开浏览器
Future<void> openBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }else{
    print('无法打开: $url');
  }
}

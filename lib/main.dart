import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/collections/collections_page.dart';
import 'package:flutter_video_app/pages/dash/dash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_video_app/pages/history/history_page.dart';
import 'package:flutter_video_app/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hans',
          countryCode: 'zh_Hans_CN',
        ),
      ],
      debugShowCheckedModeBanner: false,
      title: "Anime",
      theme: myTheme,
      home: DashPage(),
      routes: <String, WidgetBuilder>{
        CollectionsPage.routeName: (BuildContext context) =>
            CollectionsPage(), // 我的收藏
        HistoryPage.routeName: (BuildContext context) => HistoryPage(), // 历史记录
      },
    );
  }
}

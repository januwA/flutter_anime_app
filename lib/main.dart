import 'package:flutter/material.dart';
import 'package:flutter_ajanuw_router/flutter_ajanuw_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_video_app/router/router.dart';
import 'package:flutter_video_app/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String initialRoute = '/';
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
      navigatorKey: router.navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: router.forRoot(routes, initialRoute: initialRoute),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_video_app/router/router.dart';
import 'package:flutter_video_app/shared/nicotv.service.dart';
import 'package:flutter_video_app/theme/theme.dart';
import 'package:get_it/get_it.dart';
import 'package:ajanuw_http/ajanuw_http.dart' show AjanuwHttp;

import 'anime_localizations.dart';

GetIt getIt = GetIt.instance;

void main() {
  AjanuwHttp.basePath = 'http://www.nicotv.me';
  getIt..registerSingleton<NicoTvService>(NicoTvService());
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Anime",
      theme: myTheme,
      localizationsDelegates: [
        const AnimeLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AnimeLocalizations.supportedLocales,
      navigatorKey: router.navigatorKey,
      navigatorObservers: [router.navigatorObserver],
      initialRoute: '/',
      onGenerateRoute: router.forRoot(routes),
    );
  }
}

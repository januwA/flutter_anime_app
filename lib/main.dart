import 'package:flutter/material.dart';
import 'package:flutter_github_releases_service/flutter_github_releases_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_video_app/service/collections.service.dart';
import 'package:flutter_video_app/service/history.service.dart';
import 'package:flutter_video_app/router/router.dart';
import 'package:flutter_video_app/shared/nicotv.service.dart';
import 'package:flutter_video_app/theme/theme.dart';
import 'package:get_it/get_it.dart';

import 'anime_localizations.dart';
import 'shared/globals.dart';

GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt
    ..registerSingleton<NicoTvService>(NicoTvService())
    ..registerSingleton<GithubReleasesService>(GithubReleasesService(
      repo: REPO,
      owner: OWNER,
      api: GithubReleasesService.gitee,
    ))
    ..registerSingleton<CollectionsService>(CollectionsService())
    ..registerSingleton<HistoryService>(HistoryService());
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

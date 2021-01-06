import 'package:flutter/material.dart';
import 'package:flutter_github_releases_service/flutter_github_releases_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_video_app/service/collections.service.dart';
import 'package:flutter_video_app/service/history.service.dart';
import 'package:flutter_video_app/router/router.dart';
import 'package:flutter_video_app/service/nicotv.service.dart';
import 'package:flutter_video_app/service/playback_speed.service.dart';
import 'package:flutter_video_app/theme/theme.dart';
import 'package:get_it/get_it.dart';

import 'service/settings.service.dart';
import 'shared/globals.dart';

GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt
    ..registerSingleton<SettingsService>(SettingsService())
    ..registerSingleton<NicoTvService>(NicoTvService())
    ..registerSingleton<GithubReleasesService>(
      GithubReleasesService(
        repo: REPO,
        owner: OWNER,
        api: GithubReleasesService.gitee,
      ),
      dispose: (s) => s.dispose(),
    )
    ..registerSingleton<CollectionsService>(CollectionsService())
    ..registerSingleton<HistoryService>(HistoryService())
    ..registerSingleton<PlaybackSpeedService>(
      PlaybackSpeedService(),
      dispose: (s) => s.dispose(),
    );
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Anime",
      theme: myTheme,
      darkTheme: ThemeData.dark().copyWith(
        accentColor: Colors.pink,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: router.navigatorKey,
      navigatorObservers: [router.navigatorObserver],
      initialRoute: '/',
      onGenerateRoute: router.forRoot(routes),
    );
  }
}

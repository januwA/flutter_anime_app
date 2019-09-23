import 'package:flutter_github_releases_service/flutter_github_releases_service.dart';
import 'package:flutter_video_app/shared/globals.dart';
import 'package:flutter_video_app/store/collections/collections.service.dart';
import 'package:flutter_video_app/store/history/history.service.dart';
import 'package:mobx/mobx.dart';
part 'main.store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  /// 获取新版本 APK
  final GithubReleasesService versionService =
      GithubReleasesService(repo: REPO, owner: OWNER);

  /// 收藏anime服务
  final CollectionsService collectionsService = CollectionsService();

  /// 观看anime历史记录服务
  final HistoryService historyService = HistoryService();
}

MainStore mainStore = MainStore();

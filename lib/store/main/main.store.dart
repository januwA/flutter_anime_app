import 'package:flutter_video_app/store/version/version.service.dart';
import 'package:mobx/mobx.dart';
part 'main.store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  /// 获取新版本 APK
  final versionService = VersionService();
}

MainStore mainStore = MainStore();

import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_video_app/dto/github_releases/github_releases.dto.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:install_plugin/install_plugin.dart' show InstallPlugin;
import 'package:device_info/device_info.dart';
part 'version.service.g.dart';

/// 我就提供了3种apk
enum ApkTypes { arm64V8a, armeabiV7a, release }
class VersionService = _VersionService with _$VersionService;

abstract class _VersionService with Store {
  /// 默认下载胖apk
  @observable
  ApkTypes apkType = ApkTypes.release;

  String get apkName {
    if (apkType == ApkTypes.arm64V8a) {
      return 'app-arm64-v8a-release.apk';
    } else if (apkType == ApkTypes.armeabiV7a) {
      return 'app-armeabi-v7a-release.apk';
    } else {
      return 'app-release.apk';
    }
  }

  /// 是否有权限
  @observable
  bool permissisonReady = false;

  @observable
  GithubReleasesDto _latestData;

  @action
  setLatestData(GithubReleasesDto data) {
    _latestData = data;
  }

  /// github 上最新版本的数据
  @computed
  Future<GithubReleasesDto> get latestData async {
    if (_latestData == null) {
      var r = await http.get(
          'https://api.github.com/repos/januwA/flutter_anime_app/releases/latest');
      setLatestData(GithubReleasesDto.fromJson(r.body));
      return _latestData;
    } else {
      return _latestData;
    }
  }

  /// 获取用户手机支持那些Abis
  /// 更具这些Abis下载相应的apk
  Future<List<String>> get supportedAbis async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.supportedAbis;
  }

  /// 用户本地版本
  Future<String> get localVersion async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }

  /// github 上的最新版本
  Future<String> get latestVertion async => (await latestData).tagName;

  /// 是否需要更新
  /// 当用户版本与最新版本不符合即可更新
  Future<bool> get isNeedUpdate async {
    String v1 = await localVersion;
    String v2 = await latestVertion;
    return v1 != v2;
  }

  @action
  Future<void> checkVersion(BuildContext context) async {
    permissisonReady = await _checkPermission();
    if (!permissisonReady) return;
    if (await isNeedUpdate) {
      showDialogView(context);
    }
  }

  /// 显示提示弹窗
  Future<void> showDialogView(BuildContext context) async {
    if (context == null) return;
    String v1 = await localVersion;
    String v2 = await latestVertion;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('有新版本可以更新!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('当前版本: v$v1'),
                Text('最新版本: v$v2'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text(
                '确定',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _setDownloadApkType();
              },
            ),
          ],
        );
      },
    );
  }

  ///更具用户手机支持的abi， 设置下载apk的类型
  @action
  Future<void> _setDownloadApkType() async {
    List<String> abis = await supportedAbis;
    if (abis.isNotEmpty) {
      if (abis.contains('arm64-v8a')) {
        apkType = ApkTypes.arm64V8a;
      } else if (abis.contains('armeabi-v7a')) {
        apkType = ApkTypes.armeabiV7a;
      }
    }
    _downloadApk();
  }

  /// 下载最新版本的apk到用户本地
  /// 下载最优化的apk
  Future<void> _downloadApk() async {
    GithubReleasesDto body = await latestData;
    BuiltList<AssetsDto> assets = body.assets;
    if (assets.isEmpty) return;
    AssetsDto asset =
        assets.firstWhere((AssetsDto asset) => asset.name == apkName);
    if (asset == null) return;
    String browserDownloadUrl = asset.browserDownloadUrl;
    String _localPath = path.joinAll([
      (await _findLocalPath()),
      'AnimeApp',
    ]);

    // 目录不存在则创建
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    final taskId = await FlutterDownloader.enqueue(
      url: browserDownloadUrl,
      savedDir: _localPath,
      showNotification: true, // 显示状态栏中的下载进度（适用于Android）
      openFileFromNotification: true, // 点击通知打开下载的文件（适用于Android）
    );
    FlutterDownloader.registerCallback((id, status, progress) async {
      if (taskId == id && status == DownloadTaskStatus.complete) {
        File df = File(path.joinAll([_localPath, apkName]));
        if (await df.exists()) {
          _installApk(df.path);
        }
      }
    });
  }

  /// 安装指定路径的apk文件
  Future<void> _installApk(String p) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    InstallPlugin.installApk(p, info.packageName);
  }

  /// 在用户手机上找到合适下载的路径
  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  /// 检查权限，没有则提示用户给予权限
  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      // 检查当前权限状态。
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);

      if (permission != PermissionStatus.granted) {
        // 没有权限，发起请求权限
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    FlutterDownloader.registerCallback(null);
    super.dispose();
  }
}

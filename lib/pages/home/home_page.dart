import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
import 'package:flutter_video_app/pages/home/home.store.dart';
import 'package:flutter_video_app/pages/list_search/list_search.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:install_plugin/install_plugin.dart' show InstallPlugin;

final homeStore = HomeStore();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController tabController;
  bool _permissisonReady = false;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(
        vsync: this,
        initialIndex: homeStore.initialIndex,
        length: homeStore.week.length);
    tabController.addListener(() {
      homeStore.setInitialIndex(tabController.index);
    });
    _checkVertion();
  }

  Future<void> _checkVertion() async {
    _permissisonReady = await _checkPermission();
    if (!_permissisonReady) return;
    final PackageInfo info = await PackageInfo.fromPlatform();
    String localVertion = info.version;
    var r = await http.get(
        'https://api.github.com/repos/januwA/flutter_anime_app/releases/latest');
    var body = jsonDecode(r.body);
    String latestVertion = body['tag_name'];
    if (localVertion != latestVertion) {
      _showDIalog(localVertion, latestVertion, body);
    }
  }

  _showDIalog(localVertion, latestVertion, body) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('有新版本可以更新!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('当前版本: v$localVertion'),
                Text('最新版本: v$latestVertion'),
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
                List assets = body['assets'];
                String browserDownloadUrl = assets[0]['browser_download_url'];
                _downloadApp(browserDownloadUrl, assets[0]['id']);
              },
            ),
          ],
        );
      },
    );
  }

  _downloadApp(String browserDownloadUrl, appId) async {
    String _localPath = (await _findLocalPath()) + '/AnimeApp';

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
        File df = File(path.joinAll([_localPath, 'app-release.apk']));
        final PackageInfo info = await PackageInfo.fromPlatform();
        InstallPlugin.installApk(df.path, info.packageName);
      }
    });
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
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
    tabController.dispose();
    FlutterDownloader.registerCallback(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('追番表'),
            actions: <Widget>[
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      showSearch<String>(
                        context: context,
                        delegate: ListSearchPage(),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.live_tv),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => NicotvPage()));
                },
              ),
            ],
            bottom: TabBar(
              controller: tabController,
              isScrollable: true,
              tabs: homeStore.week.map((w) => Tab(text: w)).toList(),
            ),
          ),
          body: homeStore.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  controller: tabController,
                  children: [
                    for (WeekData data in homeStore.weekData)
                      GridView.count(
                        // PageStorageKey: 保存页面的滚动状态，nice
                        key: PageStorageKey<int>(data.index),
                        crossAxisCount: 2, // 每行显示几列
                        mainAxisSpacing: 2.0, // 每行的上下间距
                        crossAxisSpacing: 2.0, // 每列的间距
                        childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                        children: <Widget>[
                          for (var li in data.liData) AnimeCard(animeData: li),
                        ],
                      ),
                  ],
                ),
        );
      },
    );
  }
}

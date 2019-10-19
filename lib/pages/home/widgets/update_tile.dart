import 'package:flutter/material.dart';
import 'package:flutter_github_releases_service/flutter_github_releases_service.dart';
import 'package:flutter_video_app/router/router.dart';
import 'package:flutter_video_app/store/main/main.store.dart';

class UpdateTile extends StatefulWidget {
  @override
  _UpdateTileState createState() => _UpdateTileState();
}

class _UpdateTileState extends State<UpdateTile> {
  GithubReleasesService grs = mainStore.versionService;
  String _title = '检查更新';

  /// 下载apk事件
  Future<void> _downloadApk(bool isNeedUpdate) async {
    return isNeedUpdate && await _showDialogView()
        ? grs.downloadApk(
            downloadUrl: grs.latestSync.assets.first.browserDownloadUrl,
            apkName: grs.latestSync.assets.first.name,
          )
        : null;
  }

  /// 展示弹窗显示新版本和旧版本的版本号
  Future<bool> _showDialogView() async {
    String localVersion = await grs.localVersion;
    String latestVersion = await grs.latestVersion;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('有新版本可以更新!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('当前版本: v$localVersion'),
                Text('最新版本: v$latestVersion'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            RaisedButton(
              child: Text(
                '确定',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  /// 点击检查是否需要更新
  Future<void> _checkVersion() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text('检查更新中...')
                ],
              ),
            ),
          ],
        );
      },
    );
    bool isUpdate = await grs.isNeedUpdate;
    if (!isUpdate) {
      setState(() {
        _title = '暂无新版本';
      });
    }
    router.navigator.pop();
    _downloadApk(isUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: grs.initialized,
      builder: (c, snap) => snap.connectionState == ConnectionState.done
          ? ListTile(
              leading: Icon(Icons.autorenew),
              title: Text(_title),
              onTap: _checkVersion,
            )
          : SizedBox(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_github_releases_service/flutter_github_releases_service.dart';
import 'package:flutter_video_app/anime_localizations.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/router/router.dart';

class UpdateTile extends StatefulWidget {
  @override
  _UpdateTileState createState() => _UpdateTileState();
}

class _UpdateTileState extends State<UpdateTile> {
  final GithubReleasesService grs = getIt<GithubReleasesService>();

  bool isNeddUpdate = true;

  /// 展示弹窗显示新版本和旧版本的版本号
  Future<bool> _showDialogView() async {
    String localVersion = await grs.localVersion;
    String latestVersion = await grs.latestVersion;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AnimeLocalizations.of(context).canUpdateAppTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SelectableText('Current Version: v$localVersion'),
                SelectableText('Latest  Version: v$latestVersion'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            RaisedButton(
              child: Text(
                MaterialLocalizations.of(context).okButtonLabel,
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

  Future<void> _checkDialog() {
    return showDialog(
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
  }

  /// 1. 点击检查是否需要更新
  /// 2. 有新版本则提醒用户是否更新
  /// 3. 用户同意后，下载APK
  Future<void> _checkVersion() async {
    // 1
    _checkDialog();
    bool isNeedUpdate = await grs.isNeedUpdate;
    if (!isNeedUpdate) {
      setState(() => isNeddUpdate = false);
    }
    router.pop();

    // 2
    if (isNeedUpdate && await _showDialogView()) {
      /// 3
      grs.downloadApk(
        downloadUrl: grs.latestSync.assets.first.browserDownloadUrl,
        apkName: grs.latestSync.assets.first.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String _title = isNeddUpdate
        ? AnimeLocalizations.of(context).checkUpdate
        : AnimeLocalizations.of(context).noNewVersion;
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

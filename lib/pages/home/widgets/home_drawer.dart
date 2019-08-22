import 'package:flutter/material.dart';
import 'package:flutter_video_app/store/main/main.store.dart';
import 'package:flutter_github_releases_service/flutter_github_releases_service.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_video_app/shared/globals.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  GithubReleasesService grs = mainStore.versionService;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Image.asset(
                'assets/images/drawer_header.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.collections),
            title: Text('收藏列表'),
            onTap: () {
              // show collections
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/collection');
            },
          ),
          FutureBuilder(
            future: grs.isNeedUpdate,
            builder: (context, AsyncSnapshot<bool> snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return ListTile(
                  leading: Icon(Icons.autorenew),
                  title: Text('正在检查...'),
                );
              }
              if (snap.connectionState == ConnectionState.done) {
                if (snap.hasError) {
                  return ListTile(
                    leading: Icon(Icons.autorenew),
                    title: Text('${snap.error}'),
                  );
                }
                bool isNeedUpdate = snap.data;
                return ListTile(
                  leading: Icon(Icons.autorenew),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('版本更新'),
                      Text(
                        isNeedUpdate ? '点击更新' : '暂无更新',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  onTap: () => _downloadApk(isNeedUpdate),
                );
              }
              return SizedBox();
            },
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) => snap.hasData
                ? AboutListTile(
                    icon: Icon(Icons.vertical_align_bottom),
                    applicationName: snap.data.appName,
                    applicationIcon: Icon(Icons.copyright),
                    applicationVersion: snap.data.version,
                    applicationLegalese: "该app用于学习Flutter",
                    aboutBoxChildren: <Widget>[
                      ListTile(
                        selected: true,
                        title: Text('查看Anime源码'),
                        trailing: IconButton(
                          icon: Icon(Icons.open_in_browser),
                          onPressed: () async {
                            if (await canLaunch(githubAddress)) {
                              await launch(githubAddress);
                            }
                          },
                        ),
                      )
                    ],
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadApk(bool isNeedUpdate) async {
    return isNeedUpdate && await _showDialogView()
        ? grs.downloadApk(
            downloadUrl: grs.latestSync.assets.first.browserDownloadUrl,
            apkName: grs.latestSync.assets.first.name,
          )
        : null;
  }

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
}

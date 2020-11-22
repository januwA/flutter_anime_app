import 'package:flutter/material.dart';
import 'package:flutter_github_releases_service/flutter_github_releases_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info/package_info.dart';

import 'package:flutter_video_app/shared/globals.dart';
import 'package:flutter_video_app/utils/open_browser.dart';

import '../../../main.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  var grs = getIt<GithubReleasesService>();

  /// 展示弹窗显示新版本和旧版本的版本号
  Future<bool> _showDialogView() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).canUpdateAppTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SelectableText('Current Version: v${grs.localVersion}'),
                SelectableText('Latest  Version: v${grs.latestVersion}'),
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Image.asset(
              'assets/drawer_header.jpg',
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            leading: Icon(Icons.collections),
            title: Text(AppLocalizations.of(context).collectionList),
            onTap: () => Navigator.of(context).popAndPushNamed('/collections'),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text(AppLocalizations.of(context).historicalRecord),
            onTap: () => Navigator.of(context).popAndPushNamed('/history'),
          ),
          FutureBuilder(
            future: grs.initialized,
            builder: (c, snap) => snap.connectionState == ConnectionState.done
                ? ListTile(
                    leading: Icon(Icons.autorenew),
                    title: Text(grs.isNeedUpdate
                        ? AppLocalizations.of(context).checkUpdate
                        : AppLocalizations.of(context).noNewVersion),
                    onTap: () async {
                      // 用户同意后下载新版本apk
                      if (grs.isNeedUpdate && await _showDialogView()) {
                        grs.downloadApk(
                          downloadUrl:
                              grs.latest.assets.first.browserDownloadUrl,
                          apkName: grs.latest.assets.first.name,
                        );
                      }
                    },
                  )
                : SizedBox(),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) => snap.hasData
                ? AboutListTile(
                    icon: Icon(Icons.vertical_align_bottom),
                    applicationName: "Anime",
                    applicationIcon: Icon(Icons.copyright),
                    applicationVersion: snap.data.version,
                    applicationLegalese: AppLocalizations.of(context).appDescription,
                    aboutBoxChildren: <Widget>[
                      ListTile(
                        onTap: () => openBrowser(githubAddress),
                        selected: true,
                        title: Text(AppLocalizations.of(context).sourceCode),
                        trailing: Icon(Icons.open_in_browser),
                      )
                    ],
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

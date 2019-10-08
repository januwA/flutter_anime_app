import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/collections/collections_page.dart';
import 'package:flutter_video_app/pages/history/history_page.dart';
import 'package:flutter_video_app/pages/home/widgets/update_tile.dart';
import 'package:flutter_video_app/router/router.dart';
import 'package:flutter_video_app/store/main/main.store.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_video_app/shared/globals.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
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
              router.navigator.popAndPushNamed('/collections');
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('历史记录'),
            onTap: () {
              router.navigator.popAndPushNamed('/history');
            },
          ),
          UpdateTile(),
          FutureBuilder<String>(
            future: mainStore.versionService.localVersion,
            builder: (context, snap) => snap.hasData
                ? AboutListTile(
                    icon: Icon(Icons.vertical_align_bottom),
                    applicationName: "Anime",
                    applicationIcon: Icon(Icons.copyright),
                    applicationVersion: snap.data,
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
}

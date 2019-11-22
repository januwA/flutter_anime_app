import 'package:flutter/material.dart';
import 'package:flutter_video_app/anime_localizations.dart';
import 'package:flutter_video_app/pages/home/widgets/update_tile.dart';
import 'package:flutter_video_app/store/main/main.store.dart';

import 'package:flutter_video_app/shared/globals.dart';
import 'package:flutter_video_app/utils/open_browser.dart';

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
            child: Image.asset(
              'assets/images/drawer_header.jpg',
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            leading: Icon(Icons.collections),
            title: Text(AnimeLocalizations.of(context).collectionList),
            onTap: () => Navigator.of(context).popAndPushNamed('/collections'),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text(AnimeLocalizations.of(context).historicalRecord),
            onTap: () => Navigator.of(context).popAndPushNamed('/history'),
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
                        onTap: () => openBrowser(githubAddress),
                        selected: true,
                        title: Text('查看Anime源码'),
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

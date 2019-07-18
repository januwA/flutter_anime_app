import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/home/home.store.dart';
import 'package:flutter_video_app/pages/list_search/list_search.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/store/main/main.store.dart';
import 'package:package_info/package_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomePage> {
  final HomeStore store = HomeStore();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Observer(
      builder: (_) {
        return DefaultTabController(
          length: store.week.length,
          initialIndex: store.initialIndex,
          child: Scaffold(
            appBar: AppBar(
              title: Text('追番表'),
              actions: _buildActions(),
              bottom: TabBar(
                isScrollable: true,
                tabs: store.week.map((w) => Tab(text: w)).toList(),
              ),
            ),
            drawer: _buildDrawer(),
            body: store.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : TabBarView(
                    children: [
                      for (var data in store.weekData)
                        GridView.count(
                          crossAxisCount: 2, // 每行显示几列
                          mainAxisSpacing: 2.0, // 每行的上下间距
                          crossAxisSpacing: 2.0, // 每列的间距
                          childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                          children: <Widget>[
                            for (var li in data.liData)
                              AnimeCard(animeData: li),
                          ],
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  List<Widget> _buildActions() {
    return [
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
    ];
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Image.asset('assets/images/drawer_header.jpg',
                  fit: BoxFit.cover),
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
          FutureBuilder<bool>(
            future: mainStore.versionService.isNeedUpdate,
            initialData: true,
            builder: (context, snap) => ListTile(
              leading: Icon(Icons.autorenew),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('版本更新'),
                  Text(
                    snap.data ? '有新版本可更新' : '已是最新版本',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              onTap: snap.data
                  ? () {
                      mainStore.versionService.checkVersion(context);
                    }
                  : null,
            ),
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
                          onPressed: store.toGithubRepo,
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

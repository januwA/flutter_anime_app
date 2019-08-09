import 'package:flutter/material.dart';
import 'package:flutter_github_releases_service/flutter_github_releases_service.dart';
import 'package:flutter_video_app/pages/home/home.store.dart';
import 'package:flutter_video_app/pages/list_search/list_search.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/store/main/main.store.dart';
import 'package:package_info/package_info.dart';

final HomeStore store = HomeStore();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    store.initState(this);
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('追番表'),
            actions: _buildActions(),
            bottom: TabBar(
              isScrollable: true,
              controller: store.tabController,
              tabs: store.week.map((w) => Tab(text: w)).toList(),
            ),
          ),
          drawer: HomeDrawer(),
          body: store.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  controller: store.tabController,
                  children: [
                    for (var data in store.weekData)
                      RefreshIndicator(
                        onRefresh: store.refresh,
                        child: GridView.count(
                          // PageStorageKey: 保存页面的滚动状态，nice
                          key: PageStorageKey<int>(data.index),
                          crossAxisCount: 2, // 每行显示几列
                          mainAxisSpacing: 2.0, // 每行的上下间距
                          crossAxisSpacing: 2.0, // 每列的间距
                          childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                          children: <Widget>[
                            for (var li in data.liData)
                              AnimeCard(animeData: li),
                          ],
                        ),
                      ),
                  ],
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
}

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

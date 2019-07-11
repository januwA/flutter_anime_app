import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/home/home.store.dart';
import 'package:flutter_video_app/pages/list_search/list_search.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/store/main/main.store.dart';

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
    mainStore.versionService.checkVersion(context);
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
              controller: store.tabController,
              isScrollable: true,
              tabs: store.week.map((w) => Tab(text: w)).toList(),
            ),
          ),
          body: store.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  controller: store.tabController,
                  children: [
                    for (var data in store.weekData)
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

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/recently_updated/recently_updated.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';

RecentlyUpdatedStore recentlyUpdatedStore = RecentlyUpdatedStore();

class RecentlyUpdatedPage extends StatefulWidget {
  @override
  _RecentlyUpdatedPageState createState() => _RecentlyUpdatedPageState();
}

class _RecentlyUpdatedPageState extends State<RecentlyUpdatedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        key: PageStorageKey('recently_updated'),
        slivers: <Widget>[
          SliverAppBar(
            title: Text('最近更新'),
            floating: true,
          ),
          Observer(
            builder: (_) {
              return recentlyUpdatedStore.animeList != null
                  ? SliverGrid.count(
                      crossAxisCount: 2, // 每行显示几列
                      mainAxisSpacing: 2.0, // 每行的上下间距
                      crossAxisSpacing: 2.0, // 每列的间距
                      childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                      children: <Widget>[
                        for (var anime in recentlyUpdatedStore.animeList)
                          AnimeCard(animeData: anime),
                      ],
                    )
                  : SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}

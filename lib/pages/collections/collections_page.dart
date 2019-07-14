import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_video_app/store/main/main.store.dart';

/// 我的收藏页面

class CollectionsPage extends StatefulWidget {
  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('我的收藏'),
          ),
          Observer(
            builder: (_) => mainStore.collectionsService.collections.isEmpty
                ? SliverPadding(
                    padding: EdgeInsets.all(18.0),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: Text('空落落的收藏夹~~~'),
                      ),
                    ),
                  )
                : SliverGrid.count(
                    crossAxisCount: 2, // 每行显示几列
                    mainAxisSpacing: 2.0, // 每行的上下间距
                    crossAxisSpacing: 2.0, // 每列的间距
                    childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                    children: <Widget>[
                      for (var anime
                          in mainStore.collectionsService.collections)
                        AnimeCard(animeData: anime),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

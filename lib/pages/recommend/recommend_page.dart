import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/recommend/recommend.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';

RecommendStore recommendStore = RecommendStore();

class RecommendPage extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        key: PageStorageKey('recently_updated'),
        slivers: <Widget>[
          SliverAppBar(
            title: Text('推荐动漫'),
            floating: true,
          ),
          Observer(
            builder: (_) {
              return recommendStore.animeList != null
                  ? SliverGrid.count(
                      crossAxisCount: 2, // 每行显示几列
                      mainAxisSpacing: 2.0, // 每行的上下间距
                      crossAxisSpacing: 2.0, // 每列的间距
                      childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                      children: <Widget>[
                        for (var anime in recommendStore.animeList)
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

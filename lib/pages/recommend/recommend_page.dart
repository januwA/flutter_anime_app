import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/recommend/recommend.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_video_app/shared/widgets/sliver_loading.dart';

class RecommendPage extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with AutomaticKeepAliveClientMixin<RecommendPage> {
  RecommendStore recommendStore = RecommendStore();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: CustomScrollView(
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
                  : SliverLoading();
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

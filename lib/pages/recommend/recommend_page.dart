import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/anime_localizations.dart';
import 'package:flutter_video_app/pages/recommend/recommend.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_grid_view.dart';
import 'package:flutter_video_app/shared/widgets/sliver_loading.dart';

RecommendStore store = RecommendStore();

class RecommendPage extends StatefulWidget {
  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: store.refresh,
        child: CustomScrollView(
          key: PageStorageKey('recently_updated'),
          slivers: <Widget>[
            SliverAppBar(
              title: Text(AnimeLocalizations.of(context).recommendTitle),
              floating: true,
            ),
            Observer(
              builder: (_) {
                return store.animeList != null
                    ? AnimeGridView(
                        key: ValueKey('recently_updated'),
                        sliver: true,
                        animes: store.animeList,
                      )
                    : SliverLoading();
              },
            ),
          ],
        ),
      ),
    );
  }
}

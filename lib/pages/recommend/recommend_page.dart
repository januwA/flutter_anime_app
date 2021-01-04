import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/recommend/recommend.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_grid_view.dart';

class RecommendPage extends StatelessWidget {
  final store = RecommendStore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoScrollbar(
        child: Observer(
          builder: (context) {
            return store.animeList == null
                ? Center(child: CircularProgressIndicator())
                : AnimeGridView(
                    key: PageStorageKey('recommend'),
                    animes: store.animeList,
                  );
          },
        ),
      ),
    );
  }
}

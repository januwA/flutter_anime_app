import 'package:breakpoints/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/li_data/li_data.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/service/collections.service.dart';
import 'package:flutter_video_app/sqflite_db/model/collection.dart';

import 'anime_card.dart';

/// anime的Grid列表
class AnimeGridView extends StatelessWidget {
  final CollectionsService collectionsService = getIt<CollectionsService>();

  final Key key;
  final List<LiData> animes;
  final bool sliver;

  /// 收藏的列表是异步的
  final bool wait;
  final List<Collection> waitAnimes;

  AnimeGridView({
    this.key,
    this.animes,
    this.waitAnimes,
    this.sliver = false,
    this.wait = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width.isXs
        ? 2
        : width.isSm
            ? 3
            : width.isMd
                ? 5
                : 8;
    final double mainAxisSpacing = 2.0; // 每行的上下间距
    final double crossAxisSpacing = 2.0; // 每列的间距

    var _result;
    if (wait) {
      _result = waitAnimes
          .map((Collection c) => FutureBuilder(
              future: collectionsService.getAnime(c.animeId),
              builder: (context, AsyncSnapshot<LiData> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snap.connectionState == ConnectionState.done) {
                  return AnimeCard(animeData: snap.data);
                }
                return SizedBox();
              }))
          .toList();
    } else {
      _result = animes
          .map((anime) => AnimeCard(key: ValueKey(anime.id), animeData: anime))
          .toList();
    }
    if (sliver) {
      return SliverGrid.count(
        // PageStorageKey: 保存页面的滚动状态，nice
        key: key,
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: AnimeCard.aspectRatio,
        children: _result,
      );
    }
    return GridView.count(
      key: key,
      padding: EdgeInsets.zero,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: AnimeCard.aspectRatio,
      children: _result,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/anime_localizations.dart';
import 'package:flutter_video_app/pages/recently_updated/recently_updated.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_video_app/shared/widgets/sliver_loading.dart';

final RecentlyUpdatedStore store = RecentlyUpdatedStore();

class RecentlyUpdatedPage extends StatefulWidget {
  @override
  createState() => _RecentlyUpdatedPageState();
}

class _RecentlyUpdatedPageState extends State<RecentlyUpdatedPage> {
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
              builder: (context) {
                if (store.animeList == null) {
                  return SliverLoading();
                } else {
                  return SliverGrid.count(
                    crossAxisCount: 2, // 每行显示几列
                    mainAxisSpacing: 2.0, // 每行的上下间距
                    crossAxisSpacing: 2.0, // 每列的间距
                    childAspectRatio: AnimeCard.aspectRatio, //每个孩子的横轴与主轴范围的比率
                    children: <Widget>[
                      for (var anime in store.animeList)
                        AnimeCard(animeData: anime),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

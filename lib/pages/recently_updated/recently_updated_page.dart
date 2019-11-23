import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/anime_localizations.dart';
import 'package:flutter_video_app/pages/recently_updated/recently_updated.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_grid_view.dart';
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
              title: Text(AnimeLocalizations.of(context).recentTitle),
              floating: true,
            ),
            Observer(
              builder: (context) {
                if (store.animeList == null) {
                  return SliverLoading();
                } else {
                  return AnimeGridView(
                    key: ValueKey('recently_updated'),
                    sliver: true,
                    animes: store.animeList,
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

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/recently_updated/recently_updated.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_grid_view.dart';

class RecentlyUpdatedPage extends StatelessWidget {
  final store = RecentlyUpdatedStore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          return store.animeList == null
              ? Center(child: CircularProgressIndicator())
              : AnimeGridView(
                  key: PageStorageKey('recently_updated'),
                  animes: store.animeList,
                );
        },
      ),
    );
  }
}

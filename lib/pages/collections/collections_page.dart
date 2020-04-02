import 'package:flutter/material.dart';
import 'package:flutter_video_app/anime_localizations.dart';
import 'package:flutter_video_app/db/app_database.dart';
import 'package:flutter_video_app/shared/widgets/anime_grid_view.dart';
import 'package:flutter_video_app/store/main/main.store.dart';

/// 我的收藏页面
class CollectionsPage extends StatefulWidget {
  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  Widget build(BuildContext context) {
    var centerLoading = Center(child: CircularProgressIndicator());
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(AnimeLocalizations.of(context).collectionList),
            floating: true,
          ),
          StreamBuilder<List<Collection>>(
            stream: mainStore.collectionsService.collections$,
            builder: (context, AsyncSnapshot<List<Collection>> snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(child: centerLoading);
              }

              if (snap.data.isEmpty) {
                return SliverPadding(
                  padding: EdgeInsets.all(18.0),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.hourglass_empty),
                          Text('Empty of collection'),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return AnimeGridView(
                key: ValueKey("collectings"),
                waitAnimes: snap.data,
                sliver: true,
                wait: true,
              );
            },
          ),
        ],
      ),
    );
  }
}

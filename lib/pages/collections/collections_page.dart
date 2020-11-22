import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/service/collections.service.dart';
import 'package:flutter_video_app/shared/widgets/anime_grid_view.dart';
import 'package:flutter_video_app/sqflite_db/model/collection.dart';

/// 我的收藏页面
class CollectionsPage extends StatefulWidget {
  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final CollectionsService collectionsService = getIt<CollectionsService>();
  @override
  Widget build(BuildContext context) {
    var centerLoading = Center(child: CircularProgressIndicator());
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(AppLocalizations.of(context).collectionList),
            floating: true,
          ),
          FutureBuilder<List<Collection>>(
            future: collectionsService.collections,
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

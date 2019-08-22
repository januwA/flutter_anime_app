import 'package:flutter/material.dart';
import 'package:flutter_video_app/db/collections/collections.moor.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_video_app/store/main/main.store.dart';

/// 我的收藏页面

class CollectionsPage extends StatefulWidget {
  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('我的收藏'),
            floating: true,
          ),
          StreamBuilder<List<Collection>>(
            stream: mainStore.collectionsService.collections$,
            builder: (context, AsyncSnapshot<List<Collection>> snap) {
              var status = snap.connectionState;
              if (status == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
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

              return SliverGrid.count(
                crossAxisCount: 2, // 每行显示几列
                mainAxisSpacing: 2.0, // 每行的上下间距
                crossAxisSpacing: 2.0, // 每列的间距
                childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                children: snap.data.map((Collection c) {
                  return FutureBuilder(
                      future: mainStore.collectionsService.getAnime(c.animeId),
                      builder: (context, AsyncSnapshot<LiData> snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snap.connectionState == ConnectionState.done) {
                          return AnimeCard(animeData: snap.data);
                        }

                        return SizedBox();
                      });
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:anime_app/dto/li_data/li_data.dart';
import 'package:anime_app/main.dart';
import 'package:anime_app/pages/list_search/widgets/search_list_placeholder.dart';
import 'package:anime_app/service/nicotv.service.dart';
import 'package:anime_app/shared/widgets/anime_card.dart';

class ListResults extends StatefulWidget {
  final String query;

  const ListResults({Key key, this.query}) : super(key: key);

  @override
  _ListResultsState createState() => _ListResultsState();
}

class _ListResultsState extends State<ListResults> {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入

  @override
  Widget build(BuildContext context) {
    String query = widget.query;

    if (query.isEmpty) return SearchListPlaceholder();

    return FutureBuilder(
      future: nicoTvService.getSearch(query),
      initialData: <LiData>[],
      builder: (context, AsyncSnapshot<List<LiData>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            List<LiData> list = snapshot.data;
            if (list?.isEmpty ?? true) Center(child: Text('$query共有0个视频!'));
            return _displayResultList(list);
          default:
            return SizedBox();
        }
      },
    );
  }

  /// 显示用户搜索结果列表
  Widget _displayResultList(List<LiData> list) {
    return CustomScrollView(
      key: PageStorageKey<String>('search_result'),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: '${widget.query}',
                      style: TextStyle(color: Colors.red)),
                  TextSpan(text: '共有'),
                  TextSpan(
                      text: '${list.length}',
                      style: TextStyle(color: Colors.red)),
                  TextSpan(text: '个视频!'),
                ],
              ),
            ),
          ),
        ),
        SliverGrid.count(
          crossAxisCount: 2,
          // 每行显示几列
          mainAxisSpacing: 2.0,
          // 每行的上下间距
          crossAxisSpacing: 2.0,
          // 每列的间距
          childAspectRatio: AnimeCard.aspectRatio,
          //每个孩子的横轴与主轴范围的比率
          children: list.map((t) => AnimeCard(animeData: t)).toList(),
        ),
      ],
    );
  }
}

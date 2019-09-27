import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_video_app/utils/anime_list.dart';
import 'package:flutter_video_app/utils/jquery.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;

class ListResults extends StatefulWidget {
  final String query;

  const ListResults({Key key, this.query}) : super(key: key);

  @override
  _ListResultsState createState() => _ListResultsState();
}

class _ListResultsState extends State<ListResults> {
  @override
  Widget build(BuildContext context) {
    String query = widget.query;

    if (query.isEmpty)
      return Center(
        child: Text('搜索关键词'),
      );

    return FutureBuilder<http.Response>(
      future: http.get(Uri.http('www.nicotv.me', '/video/search/$query.html')),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Text('loading...');
        }
        List<dom.Element> list = _getList(snapshot.data.body);
        if (list == null || list.length == 0) {
          return Center(
            child: Text('$query共有0个视频!'),
          );
        }
        return _displayResultList(createAnimeList(list).asList());
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
          crossAxisCount: 2, // 每行显示几列
          mainAxisSpacing: 2.0, // 每行的上下间距
          crossAxisSpacing: 2.0, // 每列的间距
          childAspectRatio: AnimeCard.aspectRatio, //每个孩子的横轴与主轴范围的比率
          children: <Widget>[
            for (var anime in list) AnimeCard(animeData: anime),
          ],
        ),
      ],
    );
  }

  List<dom.Element> _getList(String body) {
    dom.Document document = html.parse(body);
    dom.Element ul = $(document, 'ul.list-unstyled');
    List<dom.Element> list = $$(ul, 'li');
    return list;
  }
}

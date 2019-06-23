import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as htmlDom;

class ListSearchPage extends SearchDelegate<String> {
  @override
  appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  /// 用户从搜索页面提交搜索后显示的结果
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: http.get(Uri.http('www.nicotv.me', '/video/search/$query.html')),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Text('loading...');
        }
        List<htmlDom.Element> list = _getList(snapshot.data.body);
        if (list == null || list.length == 0) {
          return Center(
            child: Text('$query共有0个视频!'),
          );
        }
        BuiltList<LiData> animeList = _animeList(list);
        return CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '$query', style: TextStyle(color: Colors.red)),
                      TextSpan(text: '共有'),
                      TextSpan(
                          text: '${animeList.length}',
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
              childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
              children: <Widget>[
                for (var anime in animeList) AnimeCard(animeData: anime),
              ],
            ),
          ],
        );
      },
    );
  }

  /// 当用户在搜索字段中键入查询时，在搜索页面正文中显示的建议
  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('搜索关键词'),
    );
  }

  List<htmlDom.Element> _getList(String body) {
    htmlDom.Document document = html.parse(body);
    htmlDom.Element ul = document.querySelector('ul.list-unstyled');
    List<htmlDom.Element> list = ul.querySelectorAll('li');
    return list;
  }

  BuiltList<LiData> _animeList(List<htmlDom.Element> list) {
    BuiltList<LiData> animeList = BuiltList.of(
      list.map<LiData>(
        (htmlDom.Element li) {
          var link = li.querySelector('p a').attributes['href'];
          RegExp exp = new RegExp(r"(\d+)(?=\.html$)");
          return LiData.fromJson(
            jsonEncode(
              {
                "id": exp.stringMatch(link),
                "title": li.querySelector('h2 a').attributes['title'],
                "img": li.querySelector('p a img').attributes['data-original'],
                "current":
                    li.querySelector('p a span.continu').innerHtml.trim(),
              },
            ),
          );
        },
      ),
    );
    return animeList;
  }
}

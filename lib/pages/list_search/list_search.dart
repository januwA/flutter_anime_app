import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/list_search/list_search.dto.dart';
import 'package:flutter_video_app/pages/detail/detail_page.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_video_app/utils/anime_list.dart' show createAnimeList;
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;

List<ListSearchDto> _listData;

class ListSearchPage extends SearchDelegate<String> {
  @override
  appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      textTheme: TextTheme(
        title: TextStyle(color: Colors.white),
      ),
    );
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
        var animeList = createAnimeList(list);
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
    if (_listData == null) {
      return FutureBuilder<http.Response>(
        future: http.get('http://www.nicotv.me/ajax-search.html'),
        builder: (context, snap) {
          if (snap.hasData) {
            var body = snap.data.body;
            dom.Document document = html.parse(body);
            List<dom.Element> aEls = $$(document, 'dd a');
            List<ListSearchDto> listData = aEls
                .map(
                  (dom.Element a) => ListSearchDto.fromJson(jsonEncode({
                    'id': RegExp(r"\d+").stringMatch(a.attributes['href']),
                    'text': a.innerHtml.trim(),
                    'href': a.attributes['href'],
                  })),
                )
                .toList();
            _listData = listData;
            return _popularSearches(context, _listData);
          } else {
            return Container();
          }
        },
      );
    } else {
      return _popularSearches(context, _listData);
    }
  }

  List<dom.Element> _getList(String body) {
    dom.Document document = html.parse(body);
    dom.Element ul = $(document, 'ul.list-unstyled');
    List<dom.Element> list = $$(ul, 'li');
    return list;
  }

  _popularSearches(context, List<ListSearchDto> listdata) {
    return ListView(
      children: [
        ListTile(
          title: Text(
            '热门搜索：',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        ...listdata
            .map(
              (ListSearchDto data) => ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailPage(animeId: data.id)));
                },
                title: Text(data.text),
                trailing: IconButton(
                  onPressed: () {
                    String url = 'http://www.nicotv.me${data.href}';
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NicotvPage(url: url)));
                  },
                  color: Theme.of(context).primaryColor,
                  icon: Icon(Icons.open_in_new),
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}

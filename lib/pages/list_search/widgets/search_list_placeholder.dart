import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/list_search/list_search.dto.dart';
import 'package:flutter_video_app/pages/detail/detail_page.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';
import 'package:flutter_video_app/utils/jquery.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;

class SearchListPlaceholder extends StatefulWidget {
  /// 用户开始搜索前，显示搜索建议
  SearchListPlaceholder();

  @override
  _SearchListPlaceholderState createState() => _SearchListPlaceholderState();
}

class _SearchListPlaceholderState extends State<SearchListPlaceholder> {
  List<ListSearchDto> _listData;
  String placeholderListUrl = 'http://www.nicotv.me/ajax-search.html';

  @override
  Widget build(BuildContext context) {
    if (_listData == null) {
      return FutureBuilder<http.Response>(
        future: http.get(placeholderListUrl),
        builder: (context, AsyncSnapshot<http.Response> snap) {
          if (snap.connectionState == ConnectionState.done && snap.hasData) {
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
          }
          return SizedBox();
        },
      );
    } else {
      return _popularSearches(context, _listData);
    }
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
        for (ListSearchDto data in listdata)
          ListTile(
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
          )
      ],
    );
  }
}

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:html/dom.dart' as dom;

/// 把抓取的dom列表，转化为dto数据，方便用于在卡片上面
BuiltList<LiData> createAnimeList(List<dom.Element> list) {
  BuiltList<LiData> animeList = BuiltList.of(
    list.map<LiData>(
      (dom.Element li) {
        var link = $(li, 'p a').attributes['href'];
        RegExp exp = new RegExp(r"(\d+)(?=\.html$)");
        return LiData.fromJson(
          jsonEncode({
            "id": exp.stringMatch(link),
            "title": $(li, 'h2 a').attributes['title'],
            "img": $(li, 'p a img').attributes['data-original'],
            "current": $(li, 'p a span.continu').innerHtml.trim(),
          }),
        );
      },
    ),
  );
  return animeList;
}

import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;
import 'package:mobx/mobx.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
part 'recently_updated.store.g.dart';

class RecentlyUpdatedStore = _RecentlyUpdatedStore with _$RecentlyUpdatedStore;

abstract class _RecentlyUpdatedStore with Store {
  _RecentlyUpdatedStore() {
    getData();
  }

  @observable
  BuiltList<LiData> animeList;

  /// 由于没有id，全是一样的class
  /// 先获取标题
  /// 在获取兄弟节点

  @action
  Future<void> getData() async {
    var r = await http.get(Uri.http('www.nicotv.me', ''));
    if (r.statusCode == HttpStatus.ok) {
      dom.Document document = html.parse(r.body);

      /// 获取所有标题元素
      List<dom.Element> headers = document.querySelectorAll('.page-header');

      /// 所有元素的 text
      int index = headers.indexWhere((el) => el.innerHtml.contains('最近更新'));

      /// 找到兄弟元素 获取数据
      dom.Element dataEles = headers[index]
          .nextElementSibling
          .querySelector('div.col-md-8>ul.list-unstyled');

      List<dom.Element> list = dataEles.querySelectorAll('li');
      BuiltList<LiData> aList = _animeList(list);
      animeList = aList;
    } else {
      // error
      print('error');
    }
  }

  BuiltList<LiData> _animeList(List<dom.Element> list) {
    BuiltList<LiData> animeList = BuiltList.of(
      list.map<LiData>(
        (dom.Element li) {
          var link = li.querySelector('p a').attributes['href'];
          RegExp exp = new RegExp(r"(\d+)(?=\.html$)");
          return LiData.fromJson(
            jsonEncode({
              "id": exp.stringMatch(link),
              "title": li.querySelector('h2 a').attributes['title'],
              "img": li.querySelector('p a img').attributes['data-original'],
              "current": li.querySelector('p a span.continu').innerHtml.trim(),
            }),
          );
        },
      ),
    );
    return animeList;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;

part 'home.store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  _HomeStore() {
    init();
  }

  @action
  Future<void> init() async {
    getWeekData();
  }

  final week = <String>["周一", "周二", "周三", "周四", "周五", "周六", "周日"];
  @observable
  bool isLoading = true;

  @observable
  int initialIndex = DateTime.now().weekday - 1;

  @observable
  BuiltList<WeekData> weekData = BuiltList<WeekData>();

  @action
  void setInitialIndex(int i) {
    initialIndex = i;
  }

  @action
  Future<void> getWeekData() async {
    isLoading = true;
    weekData = await _getHomeData();
    isLoading = false;
  }

  /// 从每个li中解析出数据
  Map<String, dynamic> _queryLi(dom.Element li) {
    String link = li.querySelector('p a').attributes['href'];
    String id = RegExp(r"(?<id>\d+)(?=\.html$)").stringMatch(link);
    String title = li.querySelector('h2 a').attributes['title'];
    String img = li.querySelector('p a img').attributes['data-original'];
    String current = li.querySelector('p a span.continu').innerHtml.trim();
    return ({
      'link': link,
      'id': id,
      'title': title,
      'img': img,
      "current": current,
    });
  }

  Future<BuiltList<WeekData>> _getHomeData() async {
    var r = await http.get(Uri.http('www.nicotv.me', ''));
    if (r.statusCode == HttpStatus.ok) {
      dom.Document document = html.parse(r.body);
      List<dom.Element> weekList = document.querySelectorAll('.weekDayContent');
      List<Map<String, dynamic>> data = [];
      for (dom.Element w in weekList) {
        List<dom.Element> list = w.querySelectorAll('div.ff-col ul li');
        data.add({
          "index": weekList.indexOf(w),
          "liData": list.map((dom.Element li) => _queryLi(li)).toList(),
        });
      }
      return BuiltList.of(data.map((w) => WeekData.fromJson(jsonEncode(w))));
    } else {
      // error
      return BuiltList<WeekData>();
    }
  }
}

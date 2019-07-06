import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:mobx/mobx.dart';
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
    String link = $(li, 'p a').attributes['href'];
    String id = RegExp(r"(?<id>\d+)(?=\.html$)").stringMatch(link);
    String title = $(li, 'h2 a').attributes['title'];
    String img = $(li, 'p a img').attributes['data-original'];
    String current = $(li, 'p a span.continu').innerHtml.trim();
    return ({
      'link': link,
      'id': id,
      'title': title,
      'img': img,
      "current": current,
    });
  }

  Future<BuiltList<WeekData>> _getHomeData() async {
    dom.Document document = await $document('http://www.nicotv.me');
    List<dom.Element> weekList = $$(document, '.weekDayContent');
    List<Map<String, dynamic>> data = [];
    for (dom.Element w in weekList) {
      List<dom.Element> list = $$(w, 'div.ff-col ul li');
      data.add({
        "index": weekList.indexOf(w),
        "liData": list.map((dom.Element li) => _queryLi(li)).toList(),
      });
    }
    return BuiltList.of(data.map((w) => WeekData.fromJson(jsonEncode(w))));
  }
}

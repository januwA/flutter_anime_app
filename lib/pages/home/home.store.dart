import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
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
    _getWeekData();
  }

  @action
  initState(TickerProvider  ctx) {
    tabController = TabController(
      vsync: ctx,
      initialIndex: initialIndex,
      length: week.length,
    )..addListener(() {
        setInitialIndex(tabController.index);
      });
  }

  final week = <String>["周一", "周二", "周三", "周四", "周五", "周六", "周日"];
  TabController tabController;
  @observable
  bool isLoading = true;

  @observable
  int initialIndex = DateTime.now().weekday - 1;

  @action
  void setInitialIndex(int i) {
    initialIndex = i;
  }

  @observable
  List<WeekData> weekData = List<WeekData>();

  @action
  Future<void> _getWeekData() async {
    isLoading = true;
    dom.Document document = await $document('http://www.nicotv.me');
    List<dom.Element> weekList = $$(document, '.weekDayContent');
    weekData = weekList.map((dom.Element w) {
      List<dom.Element> list = $$(w, 'div.ff-col ul li');
      return WeekData.fromJson(jsonEncode({
        "index": weekList.indexOf(w),
        "liData": list.map((dom.Element li) => _queryLi(li)).toList(),
      }));
    }).toList();
    isLoading = false;
  }

  /// 下拉刷新
  Future<void> refresh() async {
    _getWeekData();
  }

  /// 从每个li中解析出数据
  Map<String, dynamic> _queryLi(dom.Element li) {
    String link = $(li, 'p a').attributes['href'];
    String id = RegExp(r"(?<id>\d+)(?=\.html$)").stringMatch(link);
    String title = $(li, 'h2 a').attributes['title'];
    String img = $(li, 'p a img').attributes['data-original'];
    String current = $(li, 'p a span.continu').innerHtml.trim();
    return {
      'link': link,
      'id': id,
      'title': title,
      'img': img,
      "current": current,
    };
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
}

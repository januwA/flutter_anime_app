import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/utils/anime_list.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:html/dom.dart' as dom;
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
part 'anime_types.store.g.dart';

class AnimeTypesStore = _AnimeTypesStore with _$AnimeTypesStore;

abstract class _AnimeTypesStore with Store {
  _AnimeTypesStore() {
    getData();
  }

  @action
  initState(TickerProvider  ctx) {
    tabTypesCtrl = TabController(
      vsync: ctx,
      length: types.length,
      initialIndex: typesCurrent,
    );
    tabAreasCtrl = TabController(
      vsync: ctx,
      length: areas.length,
      initialIndex: areasCurrent,
    );

    tabErasCtrl = TabController(
      vsync: ctx,
      length: eras.length,
      initialIndex: erasCurrent,
    );
    tabClassifyCtrl = TabController(
      vsync: ctx,
      length: classify.length,
      initialIndex: classifyCurrent,
    );

    scrollCtrl = ScrollController();
  }

  http.Client _client;

  TabController tabTypesCtrl;
  TabController tabAreasCtrl;
  TabController tabErasCtrl;
  TabController tabClassifyCtrl;
  ScrollController scrollCtrl;

  @observable
  bool loading = true;
  @observable
  ObservableList<LiData> animeData = ObservableList<LiData>();

  /// 类型
  List<String> types = [
    "全部",
    "热血",
    "恋爱",
    "科幻",
    "奇幻",
    "百合",
    "后宫",
    "励志",
    "搞笑",
    "冒险",
    "校园",
    "战斗",
    "机战",
    "运动",
    "战争",
    "萝莉"
  ];

  /// 地区
  List<String> areas = ["全部", "日本", "大陆", "欧美", "其他"];

  /// 年代
  List<String> eras = [
    "全部",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015",
    "2014",
    "2013",
    "2010-2000",
    "90年代",
    "更早"
  ];
  List<ClassifyDto> classify = [
    ClassifyDto(text: "最近热播", url: 'hits'),
    ClassifyDto(text: "最新", url: 'addtime'),
    ClassifyDto(text: "评分最高", url: 'gold'),
  ];
  @observable
  int erasCurrent = 0;
  @observable
  int areasCurrent = 0;
  @observable
  int typesCurrent = 0;

  @observable
  int classifyCurrent = 1;

  final int _initPageCount = 1;

  /// 查询页面的分页
  @observable
  int pageCount = 1;

  @action
  setPageCount(int page) {
    pageCount = page;
  }

  @computed
  String get type => typesCurrent == 0 ? '' : types[typesCurrent];

  @computed
  String get area => areasCurrent == 0 ? '' : areas[areasCurrent];

  @computed
  String get era => erasCurrent == 0 ? '' : eras[erasCurrent];

  @computed
  String get cify => classify[classifyCurrent].url;

  @computed
  String get pageUrl => pageCount == 1 ? '' : '-$pageCount';

  @computed
  String get url =>
      'http://www.nicotv.me/video/type3/$type-$area-$era----$cify$pageUrl.html';

  /// 滚动到底部，加载下一页数据
  @action
  void _addNextPageData() {
    if (loading) return;
    pageCount += 1;
    getData();
  }

  @action
  setAreasCurrent(int index) {
    areasCurrent = index;
    pageCount = _initPageCount;
    animeData.clear();
    getData();
  }

  @action
  setTypesCurrent(int index) {
    typesCurrent = index;
    pageCount = _initPageCount;
    animeData.clear();
    getData();
  }

  @action
  setErasCurrent(int index) {
    pageCount = _initPageCount;
    erasCurrent = index;
    animeData.clear();
    getData();
  }

  @action
  setClassifyCurrent(int index) {
    classifyCurrent = index;
    pageCount = _initPageCount;
    animeData.clear();
    getData();
  }

  /// 获取document
  ///
  /// 用户的操作可能很快
  /// 想清除上一次的请求，在新建一个请求
  Future<dom.Document> _getDocument(String url) async {
    _client = http.Client();
    var r = await _client.get(url);
    dom.Document document = html.parse(r.body);
    return document;
  }

  /// 获取url的数据
  ///
  /// 1. 先获取分页
  /// 2. 在获取data
  @action
  getData() async {
    loading = true;
    _client?.close();
    try {
      dom.Document document = await _getDocument(url);
      // 分页
      int allPageCount = 1;
      List<dom.Element> pagination = $$(document, '.pagination li');
      if (pagination != null && pagination.isNotEmpty) {
        String pageLen = pagination
            .map((dom.Element li) => $(li, 'a').innerHtml)
            .where((String s) => s != "»" && s != '«')
            .map((String s) => s.contains('.') ? s.replaceAll('.', '') : s)
            .last;
        allPageCount = int.parse(pageLen);
      }
      // print('current page index: $pageCount, allPageCount: $allPageCount');

      /// 分页达到最大
      if (pageCount > allPageCount) {
        /// 分页已经达到最大
        // print('超过最大分页');
        loading = false;
        return;
      }

      /// 获取页面数据
      List<dom.Element> listUnstyledLi = $$(document, '.list-unstyled li');
      if (listUnstyledLi.isEmpty) {
        print('not Data');
        loading = false;
        return;
      }

      BuiltList<LiData> ad = createAnimeList(listUnstyledLi);
      for (var a in ad) {
        animeData.add(a);
      }
      loading = false;
    } on http.ClientException catch (_) {
      // 无视掉请求中断错误
    } catch (_) {}
  }

  bool onNotification(Notification notification) {
    if (notification is ScrollEndNotification &&
        scrollCtrl.position.extentAfter == 0) {
      _addNextPageData();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _client?.close();
    tabTypesCtrl?.dispose();
    tabAreasCtrl?.dispose();
    tabClassifyCtrl?.dispose();
    tabErasCtrl?.dispose();
    scrollCtrl?.dispose();
    super.dispose();
  }
}

class ClassifyDto {
  String text;
  String url;

  ClassifyDto({this.text, this.url});
}

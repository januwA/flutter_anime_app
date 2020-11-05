import 'package:dart_printf/dart_printf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/li_data/li_data.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/service/nicotv.service.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
part 'anime_types.store.g.dart';

class AnimeTypesStore extends _AnimeTypesStore with _$AnimeTypesStore {
  static AnimeTypesStore _cache;

  AnimeTypesStore._();

  factory AnimeTypesStore() {
    _cache ??= AnimeTypesStore._();
    return _cache;
  }
}

abstract class _AnimeTypesStore with Store {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入

  _AnimeTypesStore() {
    getData();
  }

  @action
  initState(TickerProvider vsync) {
    tabTypesCtrl = TabController(
      vsync: vsync,
      length: _types.length,
      initialIndex: typesCurrent,
    );
    tabAreasCtrl = TabController(
      vsync: vsync,
      length: areas.length,
      initialIndex: areasCurrent,
    );

    tabErasCtrl = TabController(
      vsync: vsync,
      length: _yras.length,
      initialIndex: erasCurrent,
    );
    tabClassifyCtrl = TabController(
      vsync: vsync,
      length: _classify.length,
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
  List<LiData> animeData = List<LiData>();

  /// 类型
  List<String> _types = [
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
  List<String> _yras = [
    "全部",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015",
    "2014",
    "2013",
    "20002010",
    "19901999",
    "18001989"
  ];
  List<ClassifyDto> _classify = [
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
  String get type => typesCurrent == 0 ? '' : _types[typesCurrent];

  @computed
  String get area => areasCurrent == 0 ? '' : areas[areasCurrent];

  @computed
  String get era => erasCurrent == 0 ? '' : _yras[erasCurrent];

  @computed
  String get cify => _classify[classifyCurrent].url;

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

  /// 获取url的数据
  ///
  /// 1. 先获取分页
  /// 2. 在获取data
  @action
  Future<void> getData() async {
    printf('[[ %s ]]', url);
    loading = true;
    var animes = await nicoTvService.getAnimeTypes(url, pageCount);
    if (animes.isNotEmpty) {
      animeData.addAll(animes);
    }
    loading = false;
  }

  bool onNotification(Notification notification) {
    if (notification is ScrollEndNotification &&
        scrollCtrl.position.extentAfter == 0) {
      _addNextPageData();
      return true;
    }
    return false;
  }

  void dispose() {
    _client?.close();
    tabTypesCtrl?.dispose();
    tabAreasCtrl?.dispose();
    tabClassifyCtrl?.dispose();
    tabErasCtrl?.dispose();
    scrollCtrl?.dispose();
  }
}

class ClassifyDto {
  String text;
  String url;

  ClassifyDto({this.text, this.url});
}

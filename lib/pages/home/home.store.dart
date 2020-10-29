import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/service/nicotv.service.dart';
import 'package:mobx/mobx.dart';

part 'home.store.g.dart';

/// 一周有7天
const int WEEK_LEN = 7;

class HomeStore extends _HomeStore with _$HomeStore {
  static HomeStore _cache;

  HomeStore._();

  factory HomeStore() {
    _cache ??= HomeStore._();
    return _cache;
  }
}

abstract class _HomeStore with Store {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入
  BuildContext context;
  _HomeStore() {
    _getWeekData();
  }

  @action
  initState(TickerProvider vsync) {
    tabController = TabController(
      vsync: vsync,
      initialIndex: initialIndex,
      length: WEEK_LEN,
    )..addListener(() {
        setInitialIndex(tabController.index);
      });
  }

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
    weekData = await nicoTvService.getWeekAnimes();
    isLoading = false;
  }

  /// 下拉刷新
  Future<void> refresh() async {
    _getWeekData();
  }

  void dispose() {
    tabController?.dispose();
  }
}

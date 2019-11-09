import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/shared/nicotv.service.dart';
import 'package:mobx/mobx.dart';

part 'home.store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入
  _HomeStore() {
    init();
  }

  @action
  Future<void> init() async {
    _getWeekData();
  }

  @action
  initState(TickerProvider vsync) {
    tabController = TabController(
      vsync: vsync,
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
    weekData = await nicoTvService.getWeekAnimes();
    isLoading = false;
  }

  /// 下拉刷新
  Future<void> refresh() async {
    _getWeekData();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
}

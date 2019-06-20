import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_video_app/shared/globals.dart' as globals;

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
    var r = await http.get(Uri.http(globals.baseUrl, globals.weekDataUrl));
    if (r.statusCode == HttpStatus.ok) {
      WeekDataDto body = WeekDataDto.fromJson(r.body);
      weekData = body.weekData;
    } else {
      // error
    }
    isLoading = false;
  }
}

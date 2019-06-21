import 'dart:convert';
import 'dart:io';

import 'package:flutter_video_app/models/detail_data_dto/detail_data_dto.dart';
import 'package:flutter_video_app/shared/globals.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

part 'detail.store.g.dart';

class DetailStore = _DetailStore with _$DetailStore;

abstract class _DetailStore with Store {
  _DetailStore({
    this.animeId,
  }) {
    init();
  }

  @observable
  String animeId;

  @action
  Future<void> init() async {
    assert(animeId != null);
    getDetailData();
  }

  @observable
  String weekDataerror = '';

  @observable
  String videoSrcerror = '';

  @observable
  DetailData detailData;

  /// 当前播放集数
  @observable
  int currentPlayIndex = 0;

  @observable
  String src = '';

  @observable
  bool isPageLoading = true;

  var client = http.Client();

  @action
  void setSrc(String s) {
    src = s;
  }

  /// 获取detail数据
  @action
  Future<void> getDetailData() async {
    isPageLoading = true;
    var url = Uri.http(baseUrl, detailUrl, {"id": animeId});
    try {
      var r = await client.get(url);
      if (r.statusCode == HttpStatus.ok) {
        var body = DetailDataDto.fromJson(r.body);
        detailData = body.detailData;
        src = detailData.playUrlTab.first.src;
        isPageLoading = false;
        // initVideoPlaer();
      } else {
        weekDataerror = r.body.toString();
        isPageLoading = false;
      }
    } catch (_) {
      // 中断http
    }
  }

  /// 获取指定集的src
  @action
  Future<void> getVideoSrc(Function onErrorCb) async {
    var e = detailData.playUrlTab[currentPlayIndex];
    src = '';
    var url = Uri.http(baseUrl, videoSrcUrl, {"id": e.id});
    var r = await http.get(url);
    if (r.statusCode == 200) {
      src = jsonDecode(r.body)['src'];
    } else {
      // error
      videoSrcerror = r.body.toString();
      onErrorCb();
    }
  }

  @action
  void setCurrentPlayIndex(int i) {
    currentPlayIndex = i;
  }

  @override
  void dispose() {
    client?.close();
    super.dispose();
  }
}

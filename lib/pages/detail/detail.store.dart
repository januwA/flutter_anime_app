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

  final ErrorState error = ErrorState();

  @observable
  DetailData detailData;

  /// 当前播放集数
  @observable
  int currentPlayIndex = 0;

  @observable
  String src = '';

  @observable
  bool isPageLoading = true;

  /// get detail
  http.Client client = http.Client();

  /// get video src
  http.Client clientSrc;

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
        error.detail = r.body.toString();
        isPageLoading = false;
      }
    } catch (_) {
      // 中断http
    }
  }

  /// 获取指定集的src
  @action
  Future<void> getVideoSrc({
    String id,
    Function onError,
  }) async {
    src = '';
    try {
      clientSrc?.close();
      src = '';
      var url = Uri.http(baseUrl, videoSrcUrl, {"id": id});
      clientSrc = http.Client();
      var r = await clientSrc.get(url);
      if (r.statusCode == HttpStatus.ok) {
        src = jsonDecode(r.body)['src'];
      } else {
        // error
        error.src = r.body.toString();
        onError();
      }
    } on http.ClientException catch (_) {
      /// 抓取中断错误
    }
  }

  @action
  void setCurrentPlayIndex(int i) {
    currentPlayIndex = i;
  }

  @override
  void dispose() {
    client?.close();
    clientSrc?.close();
    super.dispose();
  }
}

/// error model
class ErrorState = _ErrorState with _$ErrorState;

abstract class _ErrorState with Store {
  /// 获取detail数据时错误
  @observable
  String detail;

  /// 获取video src时错误
  @observable
  String src;
}

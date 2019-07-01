import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_video_app/models/detail_data_dto/detail_data_dto.dart';
import 'package:flutter_video_app/shared/globals.dart';
import 'package:flutter_video_app/shared/widgets/alert_http_get_error.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import 'package:video_box/video.store.dart';
import 'package:video_box/video_box.dart';

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

  @observable
  Video video;

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
  bool isPageLoading = true;

  /// get detail
  http.Client client = http.Client();

  /// get video src
  http.Client clientSrc;

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
        String src = detailData.playUrlTab.first.src;
        if (!isNull(src)) {
          video = Video(
              store: VideoStore(videoDataSource: VideoDataSource.network(src)));
        } else {
          // 后台肯定出现什么意外情况没有抓取到src
        }
        isPageLoading = false;
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
    BuildContext context,
    String id,
  }) async {
    if (video == null) {
      video = Video(store: VideoStore());
    }
    video?.store?.pause();
    video?.store?.setVideoLoading(true);
    clientSrc?.close();

    try {
      var url = Uri.http(baseUrl, videoSrcUrl, {"id": id});
      clientSrc = http.Client();
      var r = await clientSrc.get(url);
      print(r.statusCode);
      if (r.statusCode == HttpStatus.ok && jsonDecode(r.body)['src'] != '') {
        String src = jsonDecode(r.body)['src'];
        video.store.setSource(VideoDataSource.network(src));
      } else {
        alertHttpGetError(
          context: context,
          title: '提示',
          text: r.body.toString(),
          okText: '确定',
        );
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
    video.dispose();
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

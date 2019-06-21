import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_video_app/models/detail_data_dto/detail_data_dto.dart';
import 'package:flutter_video_app/shared/globals.dart';
import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';
import 'package:video_player/video_player.dart';
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
  VideoPlayerController videoCtrl;

  @observable
  String weekDataerror = '';

  @observable
  String videoSrcerror = '';

  @observable
  DetailData detailData;

  /// 当前播放集数
  @observable
  int currentPlayIndex = 0;

  /// 当前播放的视频
  @computed
  PlayUrlTab get currentPlayVideo => detailData.playUrlTab[currentPlayIndex];

  @observable
  bool isPageLoading = true;

  @observable
  bool isVideoLoading = true;

  /// 当前anime播放位置
  @observable
  Duration position;

  /// anime总时长
  @observable
  Duration duration;

  /// 是否显示控制器
  @observable
  bool isShowVideoCtrl = true;

  /// 是否为全屏播放
  @observable
  bool isFullScreen = false;

  /// 25:00 or 2:00:00 总时长
  @computed
  String get durationText {
    return duration == null
        ? ''
        : duration
            .toString()
            .split('.')
            .first
            .split(':')
            .where((String e) => e != '0')
            .toList()
            .join(':');
  }

  /// 00:01 当前时间
  @computed
  String get positionText {
    return (videoCtrl == null)
        ? ''
        : position
            .toString()
            .split('.')
            .first
            .split(':')
            .where((String e) => e != '0')
            .toList()
            .join(':');
  }

  @computed
  double get sliderValue {
    if (position?.inSeconds != null && duration?.inSeconds != null) {
      return position.inSeconds / duration.inSeconds;
    } else {
      return 0.0;
    }
  }

  var client = http.Client();

  @action
  void videoListenner() {
    position = videoCtrl.value.position;
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
        isPageLoading = false;
        initVideoPlaer();
      } else {
        weekDataerror = r.body.toString();
        isPageLoading = false;
      }
    } catch (_) {
      // 中断http
    }
  }

  /// 初始化viedo控制器
  @action
  Future<void> initVideoPlaer([String src]) async {
    isVideoLoading = true;
    videoCtrl = VideoPlayerController.network(
      !isNull(src) ? src : currentPlayVideo.src,
    );

    await videoCtrl.initialize();

    videoCtrl.setVolume(1.0);
    position = videoCtrl.value.position;
    duration = videoCtrl.value.duration;
    isVideoLoading = false;

    // 用户点击了切换，加载完后自动播放
    if (!isNull(src)) {
      videoCtrl.play();
      isShowVideoCtrl = false;
    }
    videoCtrl.addListener(videoListenner);
  }

  /// 获取指定集的src
  @action
  Future<void> getVideoSrc(Function onErrorCb) async {
    var e = detailData.playUrlTab[currentPlayIndex];
    isVideoLoading = true;
    var url = Uri.http(baseUrl, videoSrcUrl, {"id": e.id});
    var r = await http.get(url);
    if (r.statusCode == 200) {
      var src = jsonDecode(r.body)['src'];
      initVideoPlaer(src);
    } else {
      // error
      videoSrcerror = r.body.toString();
      onErrorCb();
    }
  }

  @action
  void showVideoCtrl(bool show) {
    isShowVideoCtrl = show;
  }

  void setVolume() {
    if (videoCtrl.value.volume > 0) {
      videoCtrl.setVolume(0.0);
    } else {
      videoCtrl.setVolume(1.0);
    }
  }

  void seekTo(double v) {
    videoCtrl.seekTo(Duration(seconds: (v * duration.inSeconds).toInt()));
  }

  @action
  void togglePlay() {
    if (videoCtrl.value.isPlaying) {
      videoCtrl.pause();
      isShowVideoCtrl = true;
    } else {
      videoCtrl.play();
      isShowVideoCtrl = false;
    }
  }

  @action
  void setCurrentPlayIndex(int i) {
    currentPlayIndex = i;
  }

  /// 全屏播放切换事件
  onFullScreen() {
    if (isFullScreen) {
      setPortrait();
    } else {
      setLandscape();
    }
  }

  @action
  void setIsFullScreen(bool full) {
    isFullScreen = full;
  }

  /// 设置为横屏模式
  @action
  setLandscape() {
    isFullScreen = true;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  /// 设置为正常模式
  @action
  setPortrait() {
    isFullScreen = false;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    videoCtrl?.removeListener(videoListenner);
    videoCtrl?.pause();
    videoCtrl?.dispose();
    client?.close();
    if (isFullScreen) {
      setPortrait();
    }
    super.dispose();
  }
}

import 'dart:async';

import 'package:dart_printf/dart_printf.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/service/history.service.dart';
import 'package:flutter_video_app/service/nicotv.service.dart';
import 'package:flutter_video_app/service/playback_speed.service.dart';
import 'package:flutter_video_app/sqflite_db/model/history.dart';
import 'package:flutter_video_app/utils/get_extraction_code.dart';
import 'package:flutter_video_app/utils/open_browser.dart';
import 'package:flutter_video_app/utils/show_snackbar.dart';
import 'package:mobx/mobx.dart';
import 'package:video_box/video_box.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:flutter_ajanuw_android_pip/flutter_ajanuw_android_pip.dart';

part 'detail.store.g.dart';

class DetailStore = _DetailStore with _$DetailStore;

abstract class _DetailStore with Store {
  final historyService = getIt<HistoryService>();
  final nicoTvService = getIt<NicoTvService>();
  final playbackSpeedService = getIt<PlaybackSpeedService>();

  bool isDispose = false;
  StreamSubscription<double> _cancel;

  @action
  Future<void> initState(
    TickerProvider vsync,
    BuildContext context,
    String animeId,
  ) async {
    this.animeId = animeId;
    detail = await nicoTvService.getAnime(animeId);
    tabController = TabController(
      length: detail.tabs.length,
      vsync: vsync,
    );
    loading = false;

    history = await historyService.findOneByAnimeId(animeId);
    history ??=
        await historyService.create(animeId, detail.cover, detail.videoName);

    currentPlayVideo = TabsValueDto(
      (b) => b
        ..text = history.playCurrent
        ..id = history.playCurrentId
        ..boxUrl = history.playCurrentBoxUrl,
    );

    _cancel = playbackSpeedService.speed$
        .listen((value) => vc?.setPlaybackSpeed(value));

    // 网盘地址不自动打开
    if (history.playCurrent.isNotEmpty && currentPlayVideo.boxUrl.isEmpty) {
      tabClick(currentPlayVideo, context);
    }
  }

  ScrollController controller = ScrollController();

  @observable
  String animeId;

  @observable
  bool loading = true;

  @observable
  DetailDto detail;

  @observable
  VideoController vc;

  @observable
  TabController tabController;

  @observable
  TabsValueDto currentPlayVideo;

  @observable
  AnimeVideoType animeVideoType;

  History history;

  @action
  nextPlay(BuildContext context) {
    var pis = _parseCurentPlay();
    int pvIndex = pis[0];
    int currentPlayingIndex = pis[1];
    TabsDto pv = detail.tabsValues[pvIndex];
    var prevIndex = currentPlayingIndex + 1;
    if (prevIndex < pv.tabs.length) {
      TabsValueDto next = pv.tabs[prevIndex];
      tabClick(next, context);
    }
  }

  @computed
  bool get canNextPlay {
    var pis = _parseCurentPlay();
    int pvIndex = pis[0];
    int currentPlayingIndex = pis[1];
    TabsDto pv = detail.tabsValues[pvIndex];
    var prevIndex = currentPlayingIndex + 1;
    if (prevIndex < pv.tabs.length) return true;
    return false;
  }

  @action
  prevPlay(BuildContext context) {
    var pis = _parseCurentPlay();
    int pvIndex = pis[0];
    int currentPlayingIndex = pis[1];
    TabsDto pv = detail.tabsValues[pvIndex];

    int nextIndex = currentPlayingIndex - 1;
    if (nextIndex >= 0) {
      TabsValueDto next = pv.tabs[nextIndex];
      tabClick(next, context);
    }
  }

  @computed
  bool get canPrevPlay {
    var pis = _parseCurentPlay();
    int currentPlayingIndex = pis[1];
    var prevIndex = currentPlayingIndex - 1;
    if (prevIndex >= 0) return true;
    return false;
  }

  List<int> _parseCurentPlay() {
    String id = currentPlayVideo.id;
    List<String> idSplit = id.split('-');
    int pvIndex = int.parse(idSplit[1]) - 1;
    int currentPlayingIndex = int.parse(idSplit[2]) - 1;
    return [pvIndex, currentPlayingIndex];
  }

  /// 创建video controller
  @action
  void _createVC(String src, bool isInitVideoPosition) {
    var source = VideoPlayerController.network(
      src,
      formatHint:
          animeVideoType == AnimeVideoType.m3u8 ? VideoFormat.hls : null,
    );
    if (vc == null) {
      // 第一次初始化
      vc = VideoController(
        source: source,
        autoplay: true,
        initPosition:
            isInitVideoPosition ? Duration(seconds: history.position) : null,
        // customFullScreen: const MyCustomFullScreen(),
      )
        ..initialize()
        ..addFullScreenChangeListener((VideoController c, isFullScreen) {
          // 监听开启全屏，和关闭全屏的事件
          FlutterScreen.keepOn(isFullScreen);
        });
    } else {
      // 切换资源，如上一集，下一集之类的
      vc
        ..setSource(source)
        ..initPosition = Duration.zero
        ..autoplay = true
        ..initialize();
    }
    playbackSpeedService.setPlaybackSpeed();
  }

  /// 点击播放每一集
  @action
  Future<void> tabClick(TabsValueDto t, BuildContext context) async {
    currentPlayVideo = t;
    if (t.boxUrl.isNotEmpty) {
      // 网盘资源, 将网盘提取密码写入粘贴板
      Clipboard.setData(ClipboardData(text: getExtractionCode(t.text)));
      openBrowser(t.boxUrl);
      return;
    }

    printf('[[ Video ID ]] %s', t.id);
    // 视频资源,准备切换播放点击的视频
    String vSrc = await getVideoSrc(t.id, context);

    if (isDispose) return; // 避免获取资源速度过慢时，用户退出页面后视频还处于播放状态

    if (animeVideoType == AnimeVideoType.none || vSrc == null || vSrc.isEmpty) {
      return showSnackbar(context, '获取播放地址错误');
    }

    // 在历史记录中存在，并且是相同的一集，才初始化播放时间
    bool isInitVideoPosition = history != null && t.id == history.playCurrentId;
    _createVC(vSrc, isInitVideoPosition);
    updateHistory();
  }

  void updateHistory() {
    if (history == null) return;
    historyService.update(history.copyWith(
      time: DateTime.now(),
      playCurrent: currentPlayVideo?.text ?? '',
      playCurrentId: currentPlayVideo?.id,
      playCurrentBoxUrl: currentPlayVideo?.boxUrl,
      position: vc?.position?.inSeconds ?? 0,
      duration: vc?.duration?.inSeconds ?? 0,
    ));
  }

  @action
  Future<String> getVideoSrc(String videoId, BuildContext context) async {
    var source = await nicoTvService.getAnimeSource(videoId, context);
    animeVideoType = source.type;
    if (animeVideoType == AnimeVideoType.none) return null;
    return source.src;
  }

  /// 画中画
  pip() {
    if (vc != null && vc.value.isPlaying) {
      FlutterAndroidPip.pip(aspectRatio: const PipRational(16, 9));
    }
  }

  void dispose() {
    isDispose = true;
    updateHistory();
    vc?.dispose();
    tabController?.dispose();
    controller?.dispose();
    _cancel?.cancel();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_video_app/db/app_database.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/shared/nicotv.service.dart';
import 'package:flutter_video_app/store/main/main.store.dart';
import 'package:flutter_video_app/utils/open_browser.dart';
import 'package:mobx/mobx.dart';
import 'package:moor/moor.dart' as moor;
import 'package:rxdart/rxdart.dart';
import 'package:video_box/video.controller.dart';
import 'package:video_player/video_player.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:flutter_android_pip/flutter_android_pip.dart';

import '../../router/router.dart';

part 'detail.store.g.dart';

class DetailStore = _DetailStore with _$DetailStore;

abstract class _DetailStore with Store {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入

  @action
  Future<void> initState(
    TickerProvider vsync,
    BuildContext context,
    String animeId,
  ) async {
    this.animeId = animeId;
    var data = await nicoTvService.getAnime(animeId);
    detail = data;
    loading = false;
    tabController = TabController(
      length: detail.tabs.length,
      vsync: vsync,
    );
    isCollections = await mainStore.collectionsService.exist(animeId);

    if (await mainStore.historyService.exist(animeId)) {
      history = await mainStore.historyService.findOneByAnimeId(animeId);
    } else {
      var newHistory = HistorysCompanion(
        animeId: moor.Value(animeId),
        cover: moor.Value(detail.cover),
        title: moor.Value(detail.videoName),
        time: moor.Value(DateTime.now()),
        playCurrent: moor.Value(''),
        playCurrentId: moor.Value('0'),
        playCurrentBoxUrl: moor.Value(''),
        position: moor.Value(0),
        duration: moor.Value(0),
      );
      history = await mainStore.historyService.create(newHistory);
    }
    var currentPlayVideo = TabsValueDto(
      (b) => b
        ..text = history.playCurrent
        ..id = history.playCurrentId
        ..boxUrl = history.playCurrentBoxUrl,
    );

    // 网盘地址不自动打开
    if (history.playCurrent.isNotEmpty && currentPlayVideo.boxUrl.isEmpty) {
      tabClick(currentPlayVideo, context);
    }

    iframeVideo.listen((String url) {
      router.pushNamed('/full-webvideo', arguments: url);
    });
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

  @observable
  bool isCollections = false;

  History history;

  /// iframe 播放时的流
  Stream<String> get iframeVideo => _iframeVideoSubject.stream;
  final _iframeVideoSubject = BehaviorSubject<String>();

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
  bool get hasNextPlay {
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
  bool get hasPrevPlay {
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

  /// 点击播放每一集
  @action
  Future<void> tabClick(TabsValueDto t, BuildContext context) async {
    currentPlayVideo = t;
    String boxUrl = t.boxUrl;
    if (boxUrl.isNotEmpty) {
      // 网盘资源
      openBrowser(boxUrl);
    } else {
      // 视频资源,准备切换播放点击的视频
      String vSrc = await _idGetSrc(t.id);
      if (vSrc == null || vSrc.isEmpty) {
        _showSnackbar(context, '获取播放地址错误');
        return;
      }

      if (animeVideoType == AnimeVideoType.haokanBaidu) {
        var source = VideoPlayerController.network(vSrc);

        // 存在历史记录，并且是相同的一集，才初始化播放时间
        bool isInitVideoPosition =
            history != null && t.id == history.playCurrentId;
        if (vc == null) {
          vc = VideoController(
            source: source,
            autoplay: true,
            initPosition: isInitVideoPosition
                ? Duration(seconds: history.position)
                : null,
          )
            ..initialize()
            ..addFullScreenChangeListener((VideoController c) {
              FlutterScreen.keepOn(c.isFullScreen);
            });
        } else {
          vc
            ..setSource(source)
            ..setInitPosition(Duration.zero)
            ..autoplay = true
            ..initialize();
        }
      } else {
        _iframeVideoSubject.add(vSrc);
        vc?.pause();
      }
      updateHistory();
    }
  }

  void updateHistory() {
    mainStore.historyService.update(history.copyWith(
      time: DateTime.now(),
      playCurrent: currentPlayVideo?.text ?? '',
      playCurrentId: currentPlayVideo?.id,
      playCurrentBoxUrl: currentPlayVideo?.boxUrl,
      position: vc?.position?.inSeconds ?? 0,
      duration: vc?.duration?.inSeconds ?? 0,
    ));
  }

  /// 先获取所有的script的src
  /// 找到合适的src发起请求，处理返回的数据
  @action
  Future<String> _idGetSrc(String id) async {
    var source = await nicoTvService.getAnimeSource(id);
    animeVideoType = source.type;
    return source.src;
  }

  /// webview 打开
  void openInWebview() {
    router.pushNamed(
      '/nicotv',
      arguments: 'http://www.nicotv.me/video/detail/$animeId.html',
    );
  }

  /// 收藏 or 取消收藏
  @action
  Future<void> collections(BuildContext context) async {
    if (!isCollections) {
      mainStore.collectionsService.insertCollection(CollectionsCompanion(
        animeId: moor.Value(animeId),
      ));
      isCollections = true;
      _showSnackbar(context, '收藏成功 >_<');
    } else {
      mainStore.collectionsService.deleteCollection(animeId);
      isCollections = false;
      _showSnackbar(context, '已取消收藏!');
    }
  }

  void _showSnackbar(BuildContext context, String content) {
    Flushbar<Object> flush;
    flush = Flushbar(
      message: content,
      duration: Duration(seconds: 3),
      backgroundColor: Theme.of(context).primaryColor,
      mainButton: FlatButton(
        onPressed: () => flush.dismiss(true),
        child: Text("OK", style: TextStyle(color: Colors.amber)),
      ),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    )..show(context);
  }

  /// 画中画
  pip() {
    if (vc != null && vc.value.isPlaying) {
      FlutterAndroidPip.pip();
    }
  }

  void dispose() {
    updateHistory();
    vc?.dispose();
    tabController?.dispose();
    _iframeVideoSubject?.close();
    controller.dispose();
  }
}

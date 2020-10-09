import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/service/collections.service.dart';
import 'package:flutter_video_app/service/history.service.dart';
import 'package:flutter_video_app/shared/nicotv.service.dart';
import 'package:flutter_video_app/sqflite_db/model/collection.dart';
import 'package:flutter_video_app/sqflite_db/model/history.dart';
import 'package:flutter_video_app/utils/get_extraction_code.dart';
import 'package:flutter_video_app/utils/open_browser.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_box/video_box.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:flutter_ajanuw_android_pip/flutter_ajanuw_android_pip.dart';

import '../../router/router.dart';
part 'detail.store.g.dart';

class DetailStore = _DetailStore with _$DetailStore;

abstract class _DetailStore with Store {
  final CollectionsService collectionsService = getIt<CollectionsService>();
  final HistoryService historyService = getIt<HistoryService>();
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
    isCollections = await collectionsService.exist(animeId);

    if (await historyService.exist(animeId)) {
      history = await historyService.findOneByAnimeId(animeId);
    } else {
      var newHistory = History(
        animeId: animeId,
        cover: detail.cover,
        title: detail.videoName,
        time: DateTime.now(),
        playCurrent: '',
        playCurrentId: '0',
        playCurrentBoxUrl: '',
        position: 0,
        duration: 0,
      );
      history = await historyService.create(newHistory);
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

  @action
  void _createVc(String src, bool isInitVideoPosition) {
    var source = VideoPlayerController.network(src);
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
  }

  /// 点击播放每一集
  @action
  Future<void> tabClick(TabsValueDto t, BuildContext context) async {
    currentPlayVideo = t;
    if (t.boxUrl.isNotEmpty) {
      // 网盘资源, 将网盘提取密码写入粘贴板
      Clipboard.setData(ClipboardData(text: getExtractionCode(t.text)));
      openBrowser(t.boxUrl);
    } else {
      // 视频资源,准备切换播放点击的视频
      String vSrc = await _idGetSrc(t.id);
      if (vSrc == null || vSrc.isEmpty) {
        return _showSnackbar(context, '获取播放地址错误');
      }

      if (animeVideoType == AnimeVideoType.haokanBaidu) {
        // 在历史记录中存在，并且是相同的一集，才初始化播放时间
        bool isInitVideoPosition =
            history != null && t.id == history.playCurrentId;
        _createVc(vSrc, isInitVideoPosition);
      } else {
        _iframeVideoSubject.add(vSrc);
        vc?.pause();
      }
      updateHistory();
    }
  }

  void updateHistory() {
    if(history == null) return;
    historyService.update(history.copyWith(
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

  /// 浏览器打开
  void openInWebview() {
     openBrowser('http://www.nicotv.me/video/detail/$animeId.html');
  }

  /// 收藏 or 取消收藏
  @action
  Future<bool> collections(BuildContext context) async {
    if (!isCollections) {
      collectionsService.insertCollection(Collection(animeId: animeId));
      isCollections = true;
      _showSnackbar(context, '收藏成功 >_<');
    } else {
      collectionsService.deleteCollection(animeId);
      isCollections = false;
      _showSnackbar(context, '已取消收藏!');
    }
    return isCollections;
  }

  void _showSnackbar(BuildContext context, String content) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(),
      content: Text(content),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }

  /// 画中画
  pip() {
    if (vc != null && vc.value.isPlaying) {
      FlutterAndroidPip.pip(aspectRatio: const PipRational(16, 9));
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

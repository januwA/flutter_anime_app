import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_video_app/db/app_database.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/router/router.dart';
import 'package:flutter_video_app/store/main/main.store.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:flutter_video_app/utils/open_browser.dart';
import 'package:mobx/mobx.dart';
import 'package:moor/moor.dart' as moor;
import 'package:rxdart/rxdart.dart';
import 'package:video_box/video.controller.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:video_player/video_player.dart';
import 'package:flushbar/flushbar.dart';

import '../../router/router.dart';
import 'anime_video_type.dart';

part 'detail.store.g.dart';

class DetailStore = _DetailStore with _$DetailStore;

abstract class _DetailStore with Store {
  @action
  Future<void> initState(
    TickerProvider ctx,
    BuildContext context,
    String animeId,
  ) async {
    this.animeId = animeId;
    var data = await _getDetailData(animeId);
    detail = data;
    loading = false;
    tabController = TabController(
      length: detail.tabs.length,
      vsync: ctx,
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

    if (history.playCurrent.isNotEmpty) tabClick(currentPlayVideo, context);

    iframeVideo.listen((String url) {
      router.navigator.pushNamed('/full-webvideo', arguments: url);
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
  Stream<String> get iframeVideo => _iframeVideoSubject.stream.map(
        (String src) =>
            """data:text/html,<style>body{margin: 0px}</style><iframe class="embed-responsive-item" src="$src" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe>""",
      );
  final _iframeVideoSubject = BehaviorSubject<String>();

  @action
  nextPlay(BuildContext context) {
    var pis = parseCurentPlay();
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
    var pis = parseCurentPlay();
    int pvIndex = pis[0];
    int currentPlayingIndex = pis[1];
    TabsDto pv = detail.tabsValues[pvIndex];
    var prevIndex = currentPlayingIndex + 1;
    if (prevIndex < pv.tabs.length) return true;
    return false;
  }

  @action
  prevPlay(BuildContext context) {
    var pis = parseCurentPlay();
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
    var pis = parseCurentPlay();
    int currentPlayingIndex = pis[1];
    var prevIndex = currentPlayingIndex - 1;
    if (prevIndex >= 0) return true;
    return false;
  }

  List<int> parseCurentPlay() {
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
          );
        } else {
          vc.setInitPosition(Duration.zero);
          await vc.setSource(source);
          vc.play();
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

  /// 获取 anime 详情数据
  Future<DetailDto> _getDetailData(String id) async {
    dom.Document document =
        await $document('http://www.nicotv.me/video/detail/$id.html');

    dom.Element ul = $(document, '.nav.nav-tabs.ff-playurl-tab');
    List<dom.Element> ulLis = $$(ul, 'li');
    List<String> tabs = ulLis.map((dom.Element el) => $(el, 'a').text).toList();

    dom.Element ffPlayurlTab = $(document, '.tab-content.ff-playurl-tab');

    // ul组
    List<dom.Element> ffPlayurlTabUls = $$(ffPlayurlTab, 'ul');

    // [ { 'tabs': [{id, text, isBox}] } ]
    // 循环获取，可以过滤掉意外情况.
    List<Map<String, dynamic>> tabsValues = [];
    for (dom.Element ul in ffPlayurlTabUls) {
      List<dom.Element> lis = $$(ul, 'li');
      var _tabs = [];
      for (dom.Element li in lis) {
        dom.Element a = $(li, 'a');
        String text = a?.innerHtml?.trim();
        String id = li?.attributes['data-id'];
        if (text.contains('全部') || id == null) continue;
        String boxUrl =
            a.attributes['target'] == '_blank' ? a.attributes['href'] : "";
        Map<String, String> _tab = {
          'id': id,
          'text': text,
          'boxUrl': boxUrl,
        };
        _tabs.add(_tab);
      }

      tabsValues.add({"tabs": _tabs});
    }
    dom.Element mediaBody = $(document, '.media-body');
    List<dom.Element> dds = $$(mediaBody, 'dd');

    /// 导演,有可能没有a标签
    dom.Element directorEl = $(dds[1], 'a');
    String director = directorEl != null
        ? directorEl.innerHtml.trim()
        : dds[1].innerHtml.trim();
    return DetailDto.fromJson(jsonEncode({
      /// 封面
      'cover': $(document, '.media-left img').attributes['data-original'],

      /// video name
      'videoName': $(mediaBody, 'h2 a').innerHtml.trim(),

      /// 多少集
      'curentText': $(mediaBody, 'h2 small').innerHtml.trim(),

      /// 主演
      'starring':
          $$(dds[0], 'a').map((dom.Element a) => a.innerHtml.trim()).toList(),

      /// 导演
      'director': director,

      /// 类型
      'types':
          $$(dds[2], 'a').map((dom.Element a) => a.innerHtml.trim()).toList(),

      /// 地区
      'area': $(dds[3], 'a').innerHtml.trim(),

      /// 年份
      'years': $(dds[4], 'a').innerHtml.trim(),

      /// 剧情介绍
      'plot': $(dds[5], 'span').innerHtml.trim(),

      /// 资源类型，资源来源
      'tabs': tabs,

      /// 对应[tabs]每个资源下所有的视频资源
      'tabsValues': tabsValues,
    }));
  }

  Map<String, dynamic> _parseResponseToObject(String r) {
    String jsonData = r
        .replaceFirst('var cms_player =', '')
        .replaceAll(RegExp(r";document\.write.*"), '');
    Map<String, dynamic> jsonMap = jsonDecode(jsonData);
    return jsonMap;
  }

  /// 找到脚本名中包含'player.php'的第一个'<script>'标签
  String _findScript(List<dom.Element> scripts) {
    for (var s in scripts) {
      String src = s.attributes['src'];
      if (src != null && src.contains('player.php')) {
        return src;
      }
    }
    throw '没有找到指定的script标签，尝试检查API';
  }

  /// 先获取所有的script的src
  /// 找到合适的src发起请求，处理返回的数据
  @action
  Future<String> _idGetSrc(String id) async {
    String result;
    String url = 'http://www.nicotv.me/video/play/$id.html';

    dom.Document document = await $document(url);
    String scriptSrc = _findScript($$(document, 'script'));

    var r2 = await http.get('http://www.nicotv.me$scriptSrc');
    Map<String, dynamic> jsonMap = _parseResponseToObject(r2.body);

    // 解码url字段
    String jsonUrl = Uri.decodeFull(jsonMap['url']);

    var name = jsonMap['name'].trim();

    if (name == 'haokan_baidu') {
      animeVideoType = AnimeVideoType.haokanBaidu;

      final videoUrl = Uri.parse(jsonUrl).queryParameters['url'];

      // 避免没有拿到视频播放地址时的意外情况发生
      if (videoUrl != null) {
        result = videoUrl;
      } else {
        animeVideoType = AnimeVideoType.biaofan;
        result =
            """${jsonMap['jiexi']}$jsonUrl&time=${jsonMap['time']}&auth_key=${jsonMap['auth_key']}""";
      }
    }

    if (name == '360biaofan') {
      animeVideoType = AnimeVideoType.biaofan;
      result =
          """${jsonMap['jiexi']}$jsonUrl&time=${jsonMap['time']}&auth_key=${jsonMap['auth_key']}""";
    }

    if (name == 'youku') {
      animeVideoType = AnimeVideoType.youku;
      result = """https://5.5252e.com/p/youku.php?url=${jsonMap['url']}""";
    }

    if (name == 'qq') {
      animeVideoType = AnimeVideoType.qq;
      result = """https://5.5252e.com/p/youku.php?url=${jsonMap['url']}""";
    }
    return result;
  }

  /// webview 打开
  void openInWebview(context) {
    String url = 'http://www.nicotv.me/video/detail/$animeId.html';
    router.navigator.pushNamed('/nicotv', arguments: url);
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

  @override
  void dispose() {
    updateHistory();
    vc?.dispose();
    tabController?.dispose();
    _iframeVideoSubject?.close();
    super.dispose();
  }
}

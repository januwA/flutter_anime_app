import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';
import 'package:flutter_video_app/shared/widgets/alert_http_get_error.dart';
import 'package:flutter_video_app/store/main/main.store.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_box/video.store.dart';
import 'package:video_box/video_box.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

part 'detail.store.g.dart';

class DetailStore = _DetailStore with _$DetailStore;

abstract class _DetailStore with Store {
  @action
  Future<void> initState(ctx, animeId) async {
    this.animeId = animeId;
    isCollections = mainStore.collectionsService.exist(animeId);
    var data = await _getDetailData(animeId);
    detail = data;
    loading = false;
    tabController = TabController(
      length: detail.tabs.length,
      vsync: ctx,
    );
  }
  @observable
  String animeId;

  @observable
  bool loading = true;

  @observable
  DetailDto detail;

  @observable
  Video video;

  @observable
  TabController tabController;

  @observable
  TabsValueDto currentPlayVideo;

  @observable
  bool haokanBaidu = true;

  @observable
  bool isCollections = false;

  /// iframe 播放时的流
  Stream<String> get iframeVideo => _iframeVideoSubject.stream.map(
        (String src) =>
            """data:text/html,<iframe class="embed-responsive-item" src="$src" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe>""",
      );
  final _iframeVideoSubject = BehaviorSubject<String>();

  /// 点击播放每一集
  @action
  Future<void> tabClick(TabsValueDto t, context) async {
    currentPlayVideo = t;
    String boxUrl = t.boxUrl;
    if (boxUrl.isNotEmpty) {
      // 网盘资源
      if (await canLaunch(boxUrl)) {
        await launch(boxUrl);
      } else {
        alertHttpGetError(
          context: context,
          title: '提示',
          text: '无法启动$boxUrl',
          okText: '确定',
        );
      }
    } else {
      // 视频资源,准备切换播放点击的视频
      String vSrc = await _idGetSrc(t.id);
      if (vSrc == null || vSrc.isEmpty) {
        alertHttpGetError(
          context: context,
          text: '获取播放地址错误',
          okText: '确定',
        );
        return;
      }
      if (haokanBaidu) {
        var source = VideoDataSource.network(vSrc);
        if (video == null) {
          video = Video(
            store: VideoStore(videoDataSource: source, autoplay: true),
          );
        } else {
          await video.store.setSource(source);
          video.store.play();
        }
      } else {
        _iframeVideoSubject.add(vSrc);
        video?.store?.pause();
      }
    }
  }

  /// 获取 anime 详情数据
  Future<DetailDto> _getDetailData(String id) async {
    dom.Document document =
        await $document('http://www.nicotv.me/video/detail/$id.html');

    dom.Element ul = $(document, '.nav.nav-tabs.ff-playurl-tab');
    List<dom.Element> ulLis = $$(ul, 'li');
    List<String> tabs = ulLis.map((dom.Element el) => $(el, 'a').text).toList();

    dom.Element ffPlayurlTab = $(document, '.tab-content.ff-playurl-tab');
    List<dom.Element> ffPlayurlTabUls = $$(ffPlayurlTab, 'ul');
    var tabsValues = ffPlayurlTabUls.map((dom.Element ul) {
      List<dom.Element> lis = $$(ul, 'li');
      return {
        "tabs": lis.map((dom.Element li) {
          dom.Element a = $(li, 'a');
          String boxUrl =
              a.attributes['target'] == '_blank' ? a.attributes['href'] : "";
          return {
            'id': li?.attributes['data-id'],
            'text': a?.innerHtml?.trim(),
            'boxUrl': boxUrl,
          };
        }).toList()
      };
    }).toList();

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

  /// 先获取所有的script的src
  /// 找到合适的src发起请求，处理返回的数据
  @action
  Future<String> _idGetSrc(String id) async {
    String url = 'http://www.nicotv.me/video/play/$id.html';
    dom.Document document = await $document(url);
    List<dom.Element> ss = $$(document, 'script');
    String scriptSrc;
    for (var s in ss) {
      String src = s.attributes['src'];
      if (src != null && src.contains('player.php')) {
        scriptSrc = src;
        continue;
      }
    }

    var r2 = await http.get('http://www.nicotv.me$scriptSrc');
    String jsonData = r2.body
        .replaceFirst('var cms_player =', '')
        .replaceAll(RegExp(r";document\.write.*"), '');

    Map<String, dynamic> jsonMap = jsonDecode(jsonData);
    var name = jsonMap['name'].trim();
    String jsonUrl = jsonMap['url'];
    bool isMp4 = RegExp(r'\.mp4$').hasMatch(jsonUrl);
    if (name == 'haokan_baidu' && isMp4) {
      haokanBaidu = true;
      // xx.mp4
      return Uri.parse(jsonUrl).queryParameters['url'];
    } else if (name == '360biaofan' || name == 'haokan_baidu' && !isMp4) {
      haokanBaidu = false;
      String src =
          """${jsonMap['jiexi']}$jsonUrl&time=${jsonMap['time']}&auth_key=${jsonMap['auth_key']}""";
      return src;
    } else {
      return '';
    }
  }

  /// webview 打开
  void openInWebview(context) {
    String url = 'http://www.nicotv.me/video/detail/$animeId.html';
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NicotvPage(url: url)));
  }

  /// 收藏 or 取消收藏
  @action
  Future<void> collections(BuildContext context) async {
    var saveData = LiData(
      (b) => b
        ..id = animeId
        ..current = detail.curentText
        ..img = detail.cover
        ..title = detail.videoName,
    );
    if (!isCollections) {
      await mainStore.collectionsService.addOne(saveData);
      isCollections = true;
      _showSnackbar(context, '已收藏!');
    } else {
      await mainStore.collectionsService.remove(saveData);
      isCollections = false;
      _showSnackbar(context, '已取消收藏!');
    }
  }

  void _showSnackbar(BuildContext context, String content) {
    ScaffoldFeatureController<SnackBar, SnackBarClosedReason> ctrl;
    ctrl = Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(content),
      action: SnackBarAction(
        label: '确定',
        onPressed: () {
          ctrl.close();
        },
      ),
    ));
  }

  @override
  void dispose() {
    video?.dispose();
    tabController?.dispose();
    _iframeVideoSubject?.close();
    super.dispose();
  }
}

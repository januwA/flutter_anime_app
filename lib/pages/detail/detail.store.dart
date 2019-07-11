import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/shared/widgets/alert_http_get_error.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_box/video.store.dart';
import 'package:video_box/video_box.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

part 'detail.store.g.dart';

class DetailStore = _DetailStore with _$DetailStore;

abstract class _DetailStore with Store {
  @action
  Future<void> initState(ctx, animeId) async {
    var data = await _getDetailData(animeId);
    detailData = data;
    loading = false;
    tabController = TabController(
      length: detailData.tabs.length,
      vsync: ctx,
    );
    webviewController.listen((c) {
      c.loadUrl(iframeUrl);
    });
  }

  @observable
  bool loading = true;

  @observable
  DetailDto detailData;

  @observable
  Video video;

  @observable
  TabController tabController;

  @observable
  TabsValueDto currentPlayVideo;

  @observable
  bool haokanBaidu = true;

  @observable
  String iframe = '';

  @computed
  String get iframeUrl => 'data:text/html,$iframe';

  @observable
  BehaviorSubject<WebViewController> webviewController =
      BehaviorSubject<WebViewController>();

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
      if (vSrc == null || vSrc == '') {
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
            store: VideoStore(videoDataSource: source),
          );
        } else {
          video.store.setSource(source);
        }
      } else {
        iframe = vSrc;
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
      'director': $(dds[1], 'a').innerHtml.trim(),

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
    dom.Document document =
        await $document('http://www.nicotv.me/video/play/$id.html');
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
    if (jsonMap['name'].trim() == 'haokan_baidu') {
      haokanBaidu = true;
      String url = jsonMap['url'];
      String videoUrl = Uri.parse(url).queryParameters['url'];
      return videoUrl;
    } else if (jsonMap['name'].trim() == '360biaofan') {
      haokanBaidu = false;
      var cms = jsonMap;
      String src =
          """${cms['jiexi']}${cms['url']}&time=${cms['time']}&auth_key=${cms['auth_key']}""";
      String iframeHtml = """
  <iframe class="embed-responsive-item" src="$src" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true"></iframe>
  """;
      return iframeHtml;
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    video?.dispose();
    tabController?.dispose();
    webviewController?.close();
    super.dispose();
  }
}

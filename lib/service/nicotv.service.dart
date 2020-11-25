import 'dart:convert';

import 'package:dart_printf/dart_printf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/dto/li_data/li_data.dart';
import 'package:flutter_video_app/dto/list_search/list_search.dto.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/shared/nicotv_http.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:webview_flutter/webview_flutter.dart';

dom.Element $(parent, String select) => parent.querySelector(select);
List<dom.Element> $$(parent /*Element|Document*/, String select) =>
    parent.querySelectorAll(select);

Future<dom.Document> $document(String url) async {
  var r = await nicotvHttp.get(url);
  printf('\$document status(%d) %s', r.statusCode, url);
  return html.parse(r.body);
}

class NicoTvService {
  /// 获取一周更新的amines
  Future<List<WeekData>> getWeekAnimes() async {
    var doc = await $document('/');
    return WeekData.fromListJson(
      jsonEncode(
        $$(doc, '.weekDayContent')
            .asMap()
            .entries
            .map((e) => {
                  "index": e.key,
                  "liData": $$(e.value, 'div.ff-col ul li')
                      .map((li) => _parseLi(li))
                      .toList(),
                })
            .toList(),
      ),
    );
  }

  // RegExp _getAnimeIdExp = RegExp(r"(?<id>\d+)(?=\.html$)");
  RegExp _getAnimeIdExp = RegExp(r"\d+");

  /// 从每个li中解析出数据
  Map<String, dynamic> _parseLi(dom.Element li) {
    var a = $(li, 'p a');
    var img = $(a, 'img');

    dom.Element isnew = $(li, 'p a .new-icon') ?? null;
    String link = a.attributes['href'];
    String id = _getAnimeIdExp.stringMatch(link);
    return {
      'link': link,
      'id': id,
      'title': img.attributes['alt'],
      'img': img.attributes['data-original'],
      "current": $(a, 'span.continu').text.trim(),
      "isNew": isnew != null,
    };
  }

  /// 用户开始搜索前，显示搜索建议
  Future<List<ListSearchDto>> getSearchListPlaceholder() async =>
      ListSearchDto.fromListJson(
        jsonEncode(
          $$(await $document('/ajax-search.html'), 'dd a')
              .map(
                (a) => {
                  'id': _getAnimeIdExp.stringMatch(a.attributes['href']),
                  'text': a.innerHtml.trim(),
                  'href': a.attributes['href'],
                },
              )
              .toList(),
        ),
      );

  /// 搜索
  Future<List<LiData>> getSearch(String query) async {
    var doc = await $document('/video/search/$query.html');
    return _createAnimeList($$(doc, '.list-unstyled li'));
  }

  /// 把抓取的dom列表，转化为dto数据，方便用于在卡片上面
  List<LiData> _createAnimeList(List<dom.Element> list) {
    return LiData.fromListJson(
        jsonEncode(list.map((li) => _parseLi(li)).toList()));
  }

  /// 获取最近更新模块的animes
  Future<List<LiData>> getRecentlyUpdatedAnimes() => _getHomeModule('最近更新');

  /// 获取推荐模块的animes
  Future<List<LiData>> getRecommendAnimes() => _getHomeModule('推荐动漫');

  Future<List<LiData>> _getHomeModule(String moduleName) async {
    dom.Document document = await $document('/');

    /// 获取所有标题元素
    List<dom.Element> headers = $$(document, '.page-header');

    /// 所有元素的 text
    int index = headers.indexWhere((el) => el.innerHtml.contains(moduleName));

    /// 找到兄弟元素 获取数据
    dom.Element dataEles =
        $(headers[index].nextElementSibling, 'div.col-md-8>ul.list-unstyled');

    List<dom.Element> list = $$(dataEles, 'li');
    return _createAnimeList(list);
  }

  /// 详情数据
  Future<DetailDto> getAnime(String animeId) async {
    dom.Document document = await $document('/video/detail/$animeId.html');

    // 播放通道tabs
    dom.Element ul = $(document, '.nav.nav-tabs.ff-playurl-tab');
    List<String> tabs = ul != null
        ? $$(ul, 'li').map((el) => $(el, 'a').text.trim()).toList()
        : [];

    // 每个通道的所有资源列表
    dom.Element ffPlayurlTab = $(document, '.tab-content.ff-playurl-tab');
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

    List<Map<String, List<Map<String, dynamic>>>> listUnstyled =
        $$(document, 'ul.list-unstyled.vod-item-img')
            .map((ul) => $$(ul, 'li'))
            .map((lis) => {'item': lis.map((li) => _parseLi(li)).toList()})
            .toList();
    List<String> listUnstyledTitle = [];
    $$(document, '.page-header').forEach((e) {
      if (null == $(e, 'a')) {
        listUnstyledTitle.add(e.text.trim());
      }
    });

    return DetailDto.fromJson(jsonEncode({
      /// 封面
      'cover': $(document, '.media-left img').attributes['data-original'],

      /// video name
      'videoName': $(mediaBody, 'h2 a').text.trim(),

      /// 多少集
      'curentText': $(mediaBody, 'h2 small').text.trim(),

      /// 主演
      'starring':
          $$(dds[0], 'a').map((dom.Element a) => a.text.trim()).toList(),

      /// 导演
      'director': director,

      /// 类型
      'types': $$(dds[2], 'a').map((dom.Element a) => a.text.trim()).toList(),

      /// 地区
      'area': $(dds[3], 'a').text.trim(),

      /// 年份
      'years': $(dds[4], 'a').text.trim(),

      /// 剧情介绍
      'plot': $(dds[5], 'span').text.trim(),

      /// 资源类型，资源来源
      'tabs': tabs,

      /// 对应[tabs]每个资源下所有的视频资源
      'tabsValues': tabsValues,

      'listUnstyled': listUnstyled,
      'listUnstyledTitle': listUnstyledTitle,
    }));
  }

  /// 解析player.php返回的类容
  Map<String, dynamic> _parseResponseToMap(String scriptBody) {
    String jsonData = scriptBody
        .replaceFirst('var cms_player =', '')
        .replaceAll(RegExp(r";document\.write.*"), '');
    return jsonDecode(jsonData);
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

  /// 获取视频的播放源
  Future<AnimeSource> getAnimeSource(
    String videoId,
    BuildContext context,
  ) async {
    final res = AnimeSource(type: AnimeVideoType.none, src: '');
    final document = await $document('/video/play/$videoId.html');
    String scriptSrc = _findScript($$(document, 'script'));
    printf("[[ script src ]] %s", scriptSrc);
    var jsonMap = _parseResponseToMap(await nicotvHttp.read(scriptSrc) );

    printf('[[ Get Anime Source JsonMap ]] %o', jsonMap);

    // 解码url字段
    final jsonUrl = Uri.decodeFull(jsonMap['url']);
    var name = jsonMap['name'];
    //TODO: 解析 name=leapp, http://www.nicotv.club/video/play/11266-2-1.html

    final iframeUrl =
        "${jsonMap['url']}&time=${jsonMap['time']}&auth_key=${jsonMap['auth_key']}";
    final jiexiUrl = jsonMap['jiexi'] + iframeUrl;
    printf('[[ Source Name ]] %o', name);

    // 策略: 获取MP4 -> 在iframe中获取MP4 -> 使用webview获取m3u8 -> 使用webview播放
    try {
      // 获取MP4
      if (!name.contains('haokan_baidu')) throw 'next';

      final videoUrl = Uri.parse(jsonUrl).queryParameters['url'];
      if (videoUrl == null) throw 'next';

      printf('[[ MP4 Source ]] %s', videoUrl);
      res.type = AnimeVideoType.mp4;
      res.src = videoUrl;
    } catch (e) {
      printf('[[ Iframe Url ]] %s', iframeUrl);
      try {
        // iframe中获取MP4
        var iframeDoc = await $document(iframeUrl);
        var scriptText = $$(iframeDoc, 'script').last.text;
        var m = RegExp(r'''src="([^"]+)"\s''').firstMatch(scriptText);
        var mp4Src = m[1];
        if (mp4Src?.trim()?.isEmpty ?? true) throw 'next';
        printf('[[ MP4 Source ]] %s', mp4Src);
        res.src = mp4Src;
        res.type = AnimeVideoType.mp4;
      } catch (_) {
        // 获取m3u8
        res.src = jiexiUrl;
        printf('[[ Iframe Url Get m3u8 ]] %s', res.src);

        var result = await showDialog<AnimeSource>(
          context: context,
          child: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('获取视频资源中.',
                        style: Theme.of(context).textTheme.subtitle2),
                    SizedBox(
                      height: 10,
                      width: 10,
                      child: WebView(
                        initialUrl: res.src,
                        javascriptMode: JavascriptMode.unrestricted,
                        onRequest: (url) {
                          printf('Webview onRequest [[ %s ]]', url);

                          if (url.contains('m3u8')) {
                            Navigator.of(context).pop(AnimeSource(
                                type: AnimeVideoType.m3u8, src: url));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        printf('Source Src: %s', result.src);

        // 用户手动返回
        if (result == null) {
          res.type = AnimeVideoType.none;
        } else {
          res.src = result.src;
          res.type = result.type;
        }
      }
    }
    return res;
  }

  Future<List<LiData>> getAnimeTypes(String url, int pageCount) async {
    dom.Document document = await $document(url);
    // 分页
    int allPageCount = 1;
    List<dom.Element> pagination = $$(document, '.pagination li');
    if (pagination != null && pagination.isNotEmpty) {
      String pageLen = pagination
          .map((dom.Element li) => $(li, 'a').innerHtml)
          .where((String s) => s != "»" && s != '«')
          .map((String s) => s.contains('.') ? s.replaceAll('.', '') : s)
          .last;
      allPageCount = int.parse(pageLen);
    }
    // print('current page index: $pageCount, allPageCount: $allPageCount');

    /// 分页达到最大
    if (pageCount > allPageCount) {
      /// 分页已经达到最大
      // print('超过最大分页');
      return List<LiData>();
    }

    /// 获取页面数据
    var listUnstyledLi = $$(document, '.list-unstyled li');
    if (listUnstyledLi.isEmpty) {
      return List<LiData>();
    }

    return _createAnimeList(listUnstyledLi);
  }

  /// 获取Anime简单的展示数据
  Future<LiData> getAnimeInfo(String animeId) async {
    var document = await $document('/video/detail/$animeId.html');
    var mediaBody = $(document, '.media-body');
    return LiData.fromJson(
      jsonEncode(
        {
          "id": animeId,
          "title": $(mediaBody, 'h2 a').innerHtml.trim(),
          "img": $(document, '.media-left img').attributes['data-original'],
          "current": $(mediaBody, 'h2 small').innerHtml.trim(),
          "isNew": false,
        },
      ),
    );
  }
}

enum AnimeVideoType {
  /// 能够获取到mp4的播放地址, 高速通道
  mp4,

  m3u8,

  none,
}

/// 每集的资源
class AnimeSource {
  AnimeVideoType type;
  String src;
  AnimeSource({this.type, this.src});
}

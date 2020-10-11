import 'dart:convert';

import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/dto/li_data/li_data.dart';
import 'package:flutter_video_app/dto/list_search/list_search.dto.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/shared/nicotv_http.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;

dom.Element $(parent, String select) => parent.querySelector(select);
List<dom.Element> $$(parent /*Element|Document*/, String select) =>
    parent.querySelectorAll(select);

Future<dom.Document> $document(String url) =>
    nicotvHttp.get(url).then((r) => html.parse(r.body));

class NicoTvService {
  /// 获取一周更新的amines
  Future<List<WeekData>> getWeekAnimes() async {
    dom.Document document = await $document('/');
    List<dom.Element> weekList = $$(document, '.weekDayContent');
    return weekList.map((dom.Element w) {
      List<dom.Element> list = $$(w, 'div.ff-col ul li');
      return WeekData.fromJson(jsonEncode({
        "index": weekList.indexOf(w),
        "liData": list.map((dom.Element li) => _parseLi(li)).toList(),
      }));
    }).toList();
  }

  RegExp _parseIdExp = RegExp(r"(?<id>\d+)(?=\.html$)");

  /// 从每个li中解析出数据
  Map<String, dynamic> _parseLi(dom.Element li) {
    var a = $(li, 'p a');
    var img = $(a, 'img');

    dom.Element isnew = $(li, 'p a .new-icon') ?? null;
    String link = a.attributes['href'];
    String id = _parseIdExp.stringMatch(link);
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
  Future<List<ListSearchDto>> getSearchListPlaceholder() async {
    dom.Document document = await $document('/ajax-search.html');
    List<dom.Element> aEls = $$(document, 'dd a');
    return aEls
        .map(
          (dom.Element a) => ListSearchDto.fromJson(jsonEncode({
            'id': RegExp(r"\d+").stringMatch(a.attributes['href']),
            'text': a.innerHtml.trim(),
            'href': a.attributes['href'],
          })),
        )
        .toList();
  }

  /// 搜索
  Future<List<LiData>> getSearch(String query) async {
    dom.Document document = await $document('/video/search/$query.html');
    dom.Element ul = $(document, 'ul.list-unstyled');
    List<dom.Element> list = $$(ul, 'li');
    return _createAnimeList(list);
  }

  /// 把抓取的dom列表，转化为dto数据，方便用于在卡片上面
  List<LiData> _createAnimeList(List<dom.Element> list) {
    List<LiData> animeList = list.map<LiData>(
      (dom.Element li) {
        var link = $(li, 'p a').attributes['href'];
        RegExp exp = new RegExp(r"(\d+)(?=\.html$)");
        return LiData.fromJson(
          jsonEncode({
            "id": exp.stringMatch(link),
            "title": $(li, 'h2 a').attributes['title'],
            "img": $(li, 'p a img').attributes['data-original'],
            "current": $(li, 'p a span.continu').innerHtml.trim(),
            "isNew": false,
          }),
        );
      },
    ).toList();
    return animeList;
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

  /// 尽可能的从iframe地址中解析出MP4地址
  Future<void> _createH5VidelUrl(
      Map<String, dynamic> jsonMap, AnimeSource ras) async {
    var iframeUrl =
        """${jsonMap['url']}&time=${jsonMap['time']}&auth_key=${jsonMap['auth_key']}""";
    try {
      var r = await $document(iframeUrl);
      var scripts = $$(r, 'script');

      var scriptText = scripts.last.text;
      var m = RegExp(r'''src="([^"]+)"\s''').firstMatch(scriptText);
      var mp4Src = m[1];
      if (mp4Src.trim().isEmpty) throw Error();
      ras.src = mp4Src;
      ras.type = AnimeVideoType.haokanBaidu;
    } catch (_) {
      ras.src = jsonMap['jiexi'] + iframeUrl;
      ras.type = AnimeVideoType.other;
    }
  }

  Map<String, dynamic> _parseResponseToObject(String r) {
    String jsonData = r
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

  /// 先获取所有的script的src
  /// 找到合适的src发起请求，处理返回的数据
  Future<AnimeSource> getAnimeSource(String id) async {
    var r = AnimeSource();
    String url = '/video/play/$id.html';

    dom.Document document = await $document(url);
    String scriptSrc = _findScript($$(document, 'script'));

    var r2 = await nicotvHttp.get(scriptSrc);
    Map<String, dynamic> jsonMap = _parseResponseToObject(r2.body);

    // 解码url字段
    String jsonUrl = Uri.decodeFull(jsonMap['url']);

    String name = jsonMap['name'].trim();
    // print('video url type: ' + name);
    if (name.contains('haokan_baidu')) {
      final videoUrl = Uri.parse(jsonUrl).queryParameters['url'];
      // 避免没有拿到视频播放地址时的意外情况发生
      if (videoUrl != null) {
        r.type = AnimeVideoType.haokanBaidu;
        r.src = videoUrl;
      } else {
        await _createH5VidelUrl(jsonMap, r);
      }
    } else {
      await _createH5VidelUrl(jsonMap, r);
    }
    return r;
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
    List<dom.Element> listUnstyledLi = $$(document, '.list-unstyled li');
    if (listUnstyledLi.isEmpty) {
      return List<LiData>();
    }

    return _createAnimeList(listUnstyledLi);
  }

  /// 获取Anime简单的展示数据
  Future<LiData> getAnimeInfo(String animeId) async {
    var document = await $document('/video/detail/$animeId.html');
    dom.Element mediaBody = $(document, '.media-body');
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
  haokanBaidu,

  /// 依靠解析，使用webview播放
  other,
}

/// 每集的资源
class AnimeSource {
  AnimeVideoType type;
  String src;
  AnimeSource({this.type, this.src});
}

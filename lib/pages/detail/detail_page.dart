import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';
import 'package:flutter_video_app/shared/widgets/alert_http_get_error.dart';
import 'package:flutter_video_app/shared/widgets/http_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:video_box/video.store.dart';
import 'package:video_box/video_box.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  DetailPage({
    Key key,
    @required this.animeId,
  }) : super(key: key);

  /// anime的id
  final String animeId;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  bool loading = true;
  Map<String, dynamic> detailData;
  Video video;
  TabController _tabController;
  Map<String, dynamic> currentPlayVideo;
  bool haokanBaidu = true;
  String iframe = '';
  String get iframeUrl => 'data:text/html,$iframe';
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void dispose() {
    video?.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    var data = await getDetailData(widget.animeId);
    setState(() {
      detailData = data;
      loading = false;
    });
    _tabController = TabController(
      length: detailData['tabs'].length,
      vsync: this,
    );
  }

  Future<Map<String, dynamic>> getDetailData(String id) async {
    dom.Document document =
        await $document('http://www.nicotv.me/video/detail/$id.html');

    dom.Element ul = $(document, '.nav.nav-tabs.ff-playurl-tab');
    List<dom.Element> ulLis = $$(ul, 'li');
    List<String> tabs = ulLis.map((dom.Element el) => $(el, 'a').text).toList();

    dom.Element ffPlayurlTab = $(document, '.tab-content.ff-playurl-tab');
    List<dom.Element> ffPlayurlTabUls = $$(ffPlayurlTab, 'ul');
    List<List<Map>> tabsValues = ffPlayurlTabUls.map((dom.Element ul) {
      List<dom.Element> lis = $$(ul, 'li');
      return lis.map((dom.Element li) {
        dom.Element a = $(li, 'a');
        bool isBox = a.attributes['target'] == '_blank' ? true : false;
        return {
          'id': li.attributes['data-id'],
          'text': a.innerHtml.trim(),
          'boxUrl': isBox ? a.attributes['href'] : '',
        };
      }).toList();
    }).toList();

    dom.Element mediaBody = $(document, '.media-body');
    List<dom.Element> dds = $$(mediaBody, 'dd');
    return {
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
    };
  }

  /// 先获取所有的script的src
  /// 找到合适的src发起请求，处理返回的数据
  Future<String> idGetSrc(String id) async {
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
      setState(() {
        haokanBaidu = true;
      });
      String url = jsonMap['url'];
      print(url);
      String videoUrl = Uri.parse(url).queryParameters['url'];
      return videoUrl;
    } else if (jsonMap['name'].trim() == '360biaofan') {
      setState(() {
        haokanBaidu = false;
      });
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
  Widget build(BuildContext context) {
    if (loading) {
      return HttpLoadingPage(
        title: '加载中...',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(detailData['videoName']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () {
              String url =
                  'http://www.nicotv.me/video/detail/${widget.animeId}.html';
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NicotvPage(url: url)));
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          haokanBaidu
              ? Hero(
                  tag: detailData['cover'],
                  child: video == null
                      ? Image.network(
                          detailData['cover'],
                          fit: BoxFit.fill,
                        )
                      : video.videoBox)
              : Container(
                  height: 220,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: WebView(
                      initialUrl: iframe.isEmpty
                          ? 'data:text/html,<h4>Loading...<h4>'
                          : iframeUrl,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        if (!_controller.isCompleted) {
                          _controller.complete(webViewController);
                        }
                      },
                    ),
                  ),
                ),
          _detailInfo(),
          ExpansionTile(
            title: Text(
              detailData['plot'],
              overflow: TextOverflow.ellipsis,
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(detailData['plot']),
              ),
            ],
          ),
          Container(
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
              labelColor: Theme.of(context).primaryColor,
              controller: _tabController,
              tabs: detailData['tabs']
                  .map<Widget>((el) => Tab(
                        child: Text(el),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                for (var tv in detailData['tabsValues'])
                  ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (var t in tv)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: RaisedButton(
                            color: t == currentPlayVideo
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            onPressed: () async {
                              setState(() {
                                currentPlayVideo = t;
                              });
                              String boxUrl = t['boxUrl'];
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
                                if (t['vSrc'] == null || t['vSrc'] == '') {
                                  String vSrc = await idGetSrc(t['id']);
                                  if (vSrc == null || vSrc == '') {
                                    alertHttpGetError(
                                      context: context,
                                      text: '获取播放地址错误',
                                      okText: '确定',
                                    );
                                    return;
                                  }
                                  if (haokanBaidu) {
                                    t['vSrc'] = vSrc;
                                  } else {
                                    setState(() {
                                      iframe = vSrc;
                                    });
                                    _controller.future.then((c) {
                                      c.loadUrl(iframeUrl);
                                    });
                                  }
                                }
                                if (t['vSrc'] == '' || !haokanBaidu) return;
                                var source = VideoDataSource.network(t['vSrc']);
                                if (video == null) {
                                  setState(() {
                                    video = Video(
                                      store:
                                          VideoStore(videoDataSource: source),
                                    );
                                  });
                                } else {
                                  video.store.setSource(source);
                                }
                              }
                            },
                            child: Text(t['text']),
                          ),
                        ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _detailInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text.rich(
            TextSpan(
              text: '${detailData["videoName"]}',
              style: Theme.of(context).textTheme.title,
              children: <TextSpan>[
                TextSpan(
                    text: '${detailData["curentText"]}',
                    style: Theme.of(context).textTheme.subtitle),
              ],
            ),
          ),
          Wrap(
            children: <Widget>[
              Text('主演:'),
              for (String name in detailData['starring'])
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(name)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('导演:'),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(detailData['director'])),
            ],
          ),
          Wrap(
            children: <Widget>[
              Text('类型:'),
              for (String name in detailData['types'])
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(name)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('地区:'),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(detailData['area'])),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('年份:'),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(detailData['years'])),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_video_app/shared/widgets/alert_http_get_error.dart';
import 'package:flutter_video_app/shared/widgets/http_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;
import 'package:video_box/video.store.dart';
import 'package:video_box/video_box.dart';

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

  @override
  void dispose() {
    video?.dispose();
    _tabController.dispose();
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
    var r = await http.get('http://www.nicotv.me/video/detail/$id.html');
    dom.Document document = html.parse(r.body);

    dom.Element ul = document.querySelector('.nav.nav-tabs.ff-playurl-tab');
    List<dom.Element> ulLis = ul.querySelectorAll('li');
    List<String> tabs =
        ulLis.map((dom.Element el) => el.querySelector('a').text).toList();

    dom.Element ffPlayurlTab =
        document.querySelector('.tab-content.ff-playurl-tab');
    List<dom.Element> ffPlayurlTabUls = ffPlayurlTab.querySelectorAll('ul');
    List<List<Map>> tabsValues = ffPlayurlTabUls.map((dom.Element ul) {
      List<dom.Element> lis = ul.querySelectorAll('li');
      return lis.map((dom.Element li) {
        dom.Element a = li.querySelector('a');
        bool isBox = a.attributes['target'] == '_blank' ? true : false;
        return {
          'id': li.attributes['data-id'],
          'text': a.innerHtml.trim(),
          'boxUrl': isBox ? a.attributes['href'] : '',
        };
      }).toList();
    }).toList();

    dom.Element mediaBody = document.querySelector('.media-body');
    List<dom.Element> dds = mediaBody.querySelectorAll('dd');
    return {
      /// 封面
      'cover':
          document.querySelector('.media-left img').attributes['data-original'],

      /// video name
      'videoName': mediaBody.querySelector('h2 a').innerHtml.trim(),

      /// 多少集
      'curentText': mediaBody.querySelector('h2 small').innerHtml.trim(),

      /// 主演
      'starring': dds[0]
          .querySelectorAll('a')
          .map((dom.Element a) => a.innerHtml.trim())
          .toList(),

      /// 导演
      'director': dds[1].querySelector('a').innerHtml.trim(),

      /// 类型
      'types': dds[2]
          .querySelectorAll('a')
          .map((dom.Element a) => a.innerHtml.trim())
          .toList(),

      /// 地区
      'area': dds[3].querySelector('a').innerHtml.trim(),

      /// 年份
      'years': dds[4].querySelector('a').innerHtml.trim(),

      /// 剧情介绍
      'plot': dds[5].querySelector('span').innerHtml.trim(),

      /// 资源类型，资源来源
      'tabs': tabs,

      /// 对应[tabs]每个资源下所有的视频资源
      'tabsValues': tabsValues,
    };
  }

  /// 先获取所有的script的src
  /// 找到合适的src发起请求，处理返回的数据
  Future<String> idGetSrc(String id) async {
    var r = await http.get('http://www.nicotv.me/video/play/$id.html');
    dom.Document document = html.parse(r.body);
    List<dom.Element> ss = document.querySelectorAll('script');
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
        .replaceFirst('var cms_player = ', '')
        .replaceAll(RegExp(r";document\.write.*"), '');

    // print(jsonData);
    String url = jsonDecode(jsonData)['url'];
    String videoUrl = Uri.parse(url).queryParameters['url'];
    // print(videoUrl);
    return videoUrl;
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
      ),
      body: ListView(
        children: <Widget>[
          Hero(
            tag: detailData['cover'],
            child: video == null
                ? Image.network(
                    detailData['cover'],
                    fit: BoxFit.fill,
                  )
                : video.videoBox,
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
                                ? Colors.blue
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
                                  t['vSrc'] = vSrc;
                                }
                                if (t['vSrc'] == '') return;
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

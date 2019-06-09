import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/detail_model/detail_dto.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  DetailPage({
    Key key,
    @required this.id,
  }) : super(key: key);
  final String id;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isLoading = false;
  Data _detailData;

  /// video list
  BuiltList<PlayUrlTab> get _videos => _detailData.playUrlTab;

  /// 当前播放位置
  int _currentIndex = 0;

  /// cureent video
  PlayUrlTab get _currentVideo => _videos[_currentIndex];

  String testJson = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.http('192.168.56.1:3000', "/detail", {"id": widget.id});
    var r = await http.get(url);
    DetailDto body = DetailDto.fromJson(r.body);
    setState(() {
      _isLoading = false;
      _detailData = body.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _detailLoading();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_detailData.videoName),
      ),
      body: ListView(
        children: <Widget>[
          Text(_currentVideo.src),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${_detailData.videoName} ${_detailData.curentText}"),
                Wrap(
                  children: <Widget>[
                    Text('主演:'),
                    for (String name in _detailData.starring)
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
                        child: Text(_detailData.director)),
                  ],
                ),
                Wrap(
                  children: <Widget>[
                    Text('类型:'),
                    for (String name in _detailData.types)
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
                        child: Text(_detailData.area)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('年份:'),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(_detailData.years)),
                  ],
                ),
              ],
            ),
          ),
          ExpansionTile(
            title: Text(
              _detailData.plot,
              overflow: TextOverflow.ellipsis,
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(_detailData.plot),
              ),
            ],
          ),
          Center(
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[for (PlayUrlTab t in _videos) _playTab(t)],
            ),
          ),
        ],
      ),
    );
  }

  Scaffold _detailLoading() {
    return Scaffold(
      appBar: AppBar(title: Text('加载中...')),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// 点击每集事件
  _playTab(PlayUrlTab t) {
    return RaisedButton(
      child: Text(t.text),
      onPressed: () async {
        if (t.isBox) {
          print('打开浏览器');
          if (await canLaunch(t.src)) {
            await launch(t.src);
          } else {
            throw 'Could not launch ${t.src}';
          }
        } else {
          print('播放视频资源');
          setState(() {
            _currentIndex = _videos.indexOf(t);
          });
        }
      },
    );
  }
}

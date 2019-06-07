import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  DetailPage({
    Key key,
    @required this.id,
  }) : super(key: key);
  String id;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isLoading = false;
  var _detailData;

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
    var body = jsonDecode(r.body);
    setState(() {
      _isLoading = false;
      _detailData = body['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('加载中...')),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_detailData['videoName']),
      ),
      body: ListView(
        children: <Widget>[
          Image.network(_detailData['cover']),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                Text(
                    "${_detailData['videoName']} ${_detailData['curentText']}"),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Text('主演:'),
              for (var name in _detailData['starring'])
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
                  child: Text(_detailData['director'])),
            ],
          ),
          Row(
            children: <Widget>[
              Text('类型:'),
              for (var name in _detailData['types'])
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
                  child: Text(_detailData['area'])),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('年份:'),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(_detailData['years'])),
            ],
          ),
          ExpansionTile(
            title: Text(
              _detailData['plot'],
              overflow: TextOverflow.ellipsis,
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(_detailData['plot']),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              for (var t in _detailData['playUrlTab']) _playTab(t)
            ],
          ),
        ],
      ),
    );
  }

  _playTab(t) {
    return RaisedButton(
      child: Text(t['text']),
      onPressed: () {
        if (t['isBox']) {
          print('打开浏览器');
        } else {
          print('播放视频支援');
        }
      },
    );
  }
}

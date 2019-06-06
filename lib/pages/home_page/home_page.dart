import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/week_dto.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _week = const <String>[
    "周一",
    "周二",
    "周三",
    "周四",
    "周五",
    "周六",
    "周日",
  ];
  bool _isLoading = false;
  int _currentWeekDay = DateTime.now().weekday;
  List<dynamic> weekData;

  @override
  void initState() {
    super.initState();

    _getWeekData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: _week.length,
        initialIndex: _currentWeekDay - 1,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('追番表'),
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (var w in _week) Tab(key: ValueKey(w), text: w),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    for (var data in weekData) _list(data),
                  ],
                ),
              ),
      ),
    );
  }

  /// 更具数据返回list列表
  Widget _list(data) {
    return ListView(
      children: <Widget>[
        for (var li in data['liData'])
          ListTile(
            key: ValueKey(li['id']),
            leading: Image.network(li['img']),
            title: Text(li['title']),
            subtitle: Text(li['current']),
          ),
      ],
    );
  }

  /// 获取http数据
  void _getWeekData() async {
    setState(() {
      _isLoading = true;
    });
    Response r = await http.get('http://192.168.56.1:3000');
    setState(() {
      _isLoading = false;
      weekData = jsonDecode(r.body)['data'];
    });
  }
}

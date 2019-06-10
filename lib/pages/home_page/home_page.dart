import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/week_model/week_dto.dart';
import 'package:flutter_video_app/pages/detail_page/detail_page.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

final week = <String>["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 默认显示当天的
  int get currentWeekDay => DateTime.now().weekday;

  /// 一周的所有数据
  BuiltList<WeekData> _weekData = BuiltList<WeekData>();

  /// 用于http请求，可以被中断
  Client _client;

  ///
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    getWeekData();
  }

  @override
  void dispose() {
    super.dispose();
    _client?.close();
  }

  Future<void> getWeekData() async {
    setState(() {
      isloading = true;
    });
    _client = http.Client();
    var r = await _client.get('http://192.168.56.1:3000');
    WeekDto body = WeekDto.fromJson(r.body);
    setState(() {
      _weekData = body.data;
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('追番表'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return DefaultTabController(
      length: week.length,
      initialIndex: currentWeekDay - 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('追番表'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (var w in week) Tab(key: ValueKey(w), text: w),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (WeekData data in _weekData) _gridList(data),
          ],
        ),
      ),
    );
  }

  /// 更具数据返回list列表
  Widget _gridList(WeekData data) {
    return GridView.count(
      crossAxisCount: 2, // 每行显示几列
      mainAxisSpacing: 2.0, // 每行的上下间距
      crossAxisSpacing: 2.0, // 每列的间距
      childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
      children: <Widget>[for (var li in data.liData) _gridItem(li)],
    );
  }

  Widget _gridItem(LiData li) {
    return Card(
      key: ValueKey(li.id),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailPage(id: li.id),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Image.network(
                li.img,
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
            ListTile(
              title: Text(li.title),
              subtitle: Text(li.current),
            )
          ],
        ),
      ),
    );
  }
}

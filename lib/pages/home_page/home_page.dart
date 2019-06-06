import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/week_dto.dart';
import 'package:http/http.dart' as http;

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
  BuiltList<Data> weekData;

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
                    for (Data data in weekData) _list(data),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _gridItem(LiData li) {
    return Card(
      key: ValueKey(li.id),
      child: InkWell(
        onTap: () {
          print(li.id);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Image.network(
                li.img,
                fit: BoxFit.fill,
                height: 95,
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

  /// 更具数据返回list列表
  Widget _list(Data data) {
    return GridView.count(
      crossAxisCount: 2, // 每行显示几列
      mainAxisSpacing: 2.0, // 每行的上下间距
      crossAxisSpacing: 2.0, // 每列的间距
      childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
      children: <Widget>[for (var li in data.liData) _gridItem(li)],
    );
  }

  /// 获取http数据
  void _getWeekData() async {
    setState(() {
      _isLoading = true;
    });
    var r = await http.get('http://192.168.56.1:3000');
    WeekDto body = WeekDto.fromJson(r.body);
    setState(() {
      _isLoading = false;
      weekData = body.data;
    });
  }
}

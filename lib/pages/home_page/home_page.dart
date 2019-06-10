import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
import 'package:flutter_video_app/pages/detail_page/detail_page.dart';
import 'package:flutter_video_app/shared/globals.dart' as globals;
import 'package:flutter_video_app/shared/widgets/alert_http_get_error.dart';
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

  bool isloading = false;

  @override
  void initState() {
    super.initState();
    getWeekData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 从服务器获取数据
  Future<void> getWeekData() async {
    setState(() => isloading = true);

    try {
      var r = await http.get(Uri.http(globals.baseUrl, globals.weekDataUrl));
      if (r.statusCode == 200) {
        WeekDataDto body = WeekDataDto.fromJson(r.body);
        setState(() {
          _weekData = body.weekData;
          isloading = false;
        });
      } else {
        alertHttpGetError(
          context: context,
          text: r.body,
          onOk: () {
            getWeekData();
          },
        );
        print(r.body);
      }
    } on ClientException catch (e) {
      print('请求中断: $e');
    } catch (e) {
      print("Other Error: $e");
    }
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

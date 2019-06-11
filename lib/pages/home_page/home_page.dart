import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
import 'package:flutter_video_app/pages/detail_page/detail_page.dart';
import 'package:flutter_video_app/shared/globals.dart' as globals;
import 'package:flutter_video_app/shared/widgets/http_error_page.dart';
import 'package:flutter_video_app/shared/widgets/http_loading_page.dart';
import 'package:http/http.dart' as http;

final week = <String>["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 默认显示当天的
  int get currentWeekDay => DateTime.now().weekday;
  bool isloading = false;

  /// 从服务器获取数据
  Future<BuiltList<WeekData>> getWeekData() async {
    var r = await http.get(Uri.http(globals.baseUrl, globals.weekDataUrl));
    if (r.statusCode == 200) {
      WeekDataDto body = WeekDataDto.fromJson(r.body);
      return body.weekData;
    } else {
      return Future.error(r.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BuiltList<WeekData>>(
      future: getWeekData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {

          /// 记载数据
          case ConnectionState.waiting:
            return HttpLoadingPage(title: '追番表 ');
            break;

          /// 加载完成
          case ConnectionState.done:

            /// 未返回预知的数据
            if (snapshot.hasError) {
              return HttpErrorPage(
                body: Text(snapshot.error.toString()),
              );
            }

            /// 200 ok
            BuiltList<WeekData> weekData = snapshot.data;
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
                    for (WeekData data in weekData)
                      GridView.count(
                        crossAxisCount: 2, // 每行显示几列
                        mainAxisSpacing: 2.0, // 每行的上下间距
                        crossAxisSpacing: 2.0, // 每列的间距
                        childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                        children: <Widget>[
                          for (var li in data.liData) _gridItem(li)
                        ],
                      ),
                  ],
                ),
              ),
            );
            break;
          default:
        }
      },
    );
  }

  showDetailPage(String id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DetailPage(id: id)),
    );
  }

  Widget _gridItem(LiData li) {
    return Card(
      key: ValueKey(li.id),
      child: InkWell(
        onTap: () => showDetailPage(li.id),
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

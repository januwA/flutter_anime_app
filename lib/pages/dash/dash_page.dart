import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/anime_types/anime_types_page.dart';
import 'package:flutter_video_app/pages/dash/dash.store.dart';
import 'package:flutter_video_app/pages/home/home_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/recently_updated/recently_updated_page.dart';
import 'package:flutter_video_app/pages/recommend/recommend_page.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  final store = DashStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Observer(
        builder: (_) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: store.index,
          onTap: store.controller.jumpToPage,
          items: <BottomNavigationBarItem>[
            _navBtn(title: '首页', icon: Icons.home),
            _navBtn(title: '最近', icon: Icons.fiber_new),
            _navBtn(title: '推荐', icon: Icons.thumb_up),
            _navBtn(title: '分类', icon: Icons.toys),
          ],
        ),
      ),
      body: PageView(
        controller: store.controller,
        onPageChanged: store.onPageChanged,
        children: <Widget>[
          HomePage(),
          RecentlyUpdatedPage(),
          RecommendPage(),
          AnimeTypesPage(),
        ],
      ),
    );
  }

  BottomNavigationBarItem _navBtn({String title, IconData icon}) {
    return BottomNavigationBarItem(
        icon: Icon(icon), activeIcon: Icon(icon), title: Text(title));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/anime_types/anime_types_page.dart';
import 'package:flutter_video_app/pages/dash/dash.store.dart';
import 'package:flutter_video_app/pages/home/home_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/recently_updated/recently_updated_page.dart';
import 'package:flutter_video_app/pages/recommend/recommend_page.dart';
// import 'package:flutter_video_app/store/main/main.store.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  final dashStore = DashStore();

  @override
  void initState() {
    super.initState();
    // mainStore.versionService.checkVersion(context);
  }

  @override
  void dispose() {
    dashStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Observer(
        builder: (_) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: dashStore.index,
          onTap: dashStore.controller.jumpToPage,
          items: <BottomNavigationBarItem>[
            _navBtn(title: '首页', icon: Icons.home),
            _navBtn(title: '最近', icon: Icons.fiber_new),
            _navBtn(title: '推荐', icon: Icons.thumb_up),
            _navBtn(title: '分类', icon: Icons.toys),
          ],
        ),
      ),
      body: Observer(
        builder: (_) => PageView(
          controller: dashStore.controller,
          onPageChanged: dashStore.onPageChanged,
          children: <Widget>[
            HomePage(),
            RecentlyUpdatedPage(),
            RecommendPage(),
            AnimeTypesPage(),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navBtn({String title, IconData icon}) {
    return BottomNavigationBarItem(
        icon: Icon(icon), activeIcon: Icon(icon), title: Text(title));
  }
}

import 'dart:async';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:anime_app/pages/anime_types/anime_types_page.dart';
import 'package:anime_app/pages/dash/dash.store.dart';
import 'package:anime_app/pages/home/home_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:anime_app/pages/recently_updated/recently_updated_page.dart';
import 'package:anime_app/pages/recommend/recommend_page.dart';
import 'package:toast/toast.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  final store = DashStore();
  Timer _closeTimer;

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    if (_closeTimer?.isActive ?? false) {
      return true;
    }
    Toast.show(
      "再次点击退出",
      context,
      duration: Toast.LENGTH_SHORT,
      gravity: Toast.BOTTOM,
    );
    _closeTimer = Timer(Duration(milliseconds: 1000), null);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
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
      ),
    );
  }

  Widget _bottomNavigationBar() {
    List<NavItem> navList = [
      NavItem(
        title: AppLocalizations.of(context).dashHome,
        icon: Icons.home,
        color: Colors.pink,
      ),
      NavItem(
        title: AppLocalizations.of(context).dashRecent,
        icon: Icons.fiber_new,
        color: Colors.deepPurple,
      ),
      NavItem(
        title: AppLocalizations.of(context).dashRecommend,
        icon: Icons.thumb_up,
        color: Colors.orange,
      ),
      NavItem(
        title: AppLocalizations.of(context).dashClassification,
        icon: Icons.toys,
        color: Colors.green,
      ),
    ];
    return Observer(
      builder: (_) {
        var isDark =
            MediaQuery.of(context).platformBrightness == Brightness.dark;
        return BubbleBottomBar(
          opacity: 0.2,
          currentIndex: store.index,
          onTap: store.controller.jumpToPage,
          borderRadius: BorderRadius.circular(16),
          backgroundColor: isDark ? Colors.black : Colors.white,
          hasNotch: true,
          hasInk: true,
          items: <BubbleBottomBarItem>[
            for (var e in navList)
              BubbleBottomBarItem(
                backgroundColor: e.color,
                icon: Icon(
                  e.icon,
                  color: isDark ? Colors.white60 : Colors.grey[700],
                ),
                activeIcon: Icon(
                  e.icon,
                  color: e.color,
                ),
                title: Text(e.title),
              ),
          ],
        );
      },
    );
  }
}

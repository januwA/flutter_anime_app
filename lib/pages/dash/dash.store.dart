import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'dash.store.g.dart';

class DashStore = _DashStore with _$DashStore;

abstract class _DashStore with Store {
  PageController controller = PageController();

  List<NavItem> navList = [
    NavItem(title: '首页', icon: Icons.home, color: Colors.pink),
    NavItem(title: '最近', icon: Icons.fiber_new, color: Colors.deepPurple),
    NavItem(title: '推荐', icon: Icons.thumb_up, color: Colors.indigo),
    NavItem(title: '分类', icon: Icons.toys, color: Colors.green),
  ];

  @observable
  int index = 0;

  @action
  void onPageChanged(int x) {
    index = x;
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

class NavItem {
  final String title;
  final IconData icon;
  final Color color;

  NavItem({this.title, this.icon, this.color});
}

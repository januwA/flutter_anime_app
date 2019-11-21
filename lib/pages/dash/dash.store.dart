import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'dash.store.g.dart';

class DashStore = _DashStore with _$DashStore;

abstract class _DashStore with Store {
  PageController controller = PageController();

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

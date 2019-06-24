import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/dash/dash.store.dart';
import 'package:flutter_video_app/pages/home/home_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  final dashStore = DashStore();

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
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    activeIcon: Icon(Icons.home),
                    title: Text("Home")),
              ],
            ),
      ),
      body: Observer(
        builder: (_) => PageView(
              controller: dashStore.controller,
              onPageChanged: dashStore.onPageChanged,
              children: <Widget>[
                HomePage(),
              ],
            ),
      ),
    );
  }
}

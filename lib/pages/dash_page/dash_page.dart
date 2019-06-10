import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/home_page/home_page.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  PageController controller = PageController();
  int index = 0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: controller.jumpToPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              title: Text("Search")),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              activeIcon: Icon(Icons.list),
              title: Text("More")),
        ],
      ),
      body: PageView(
        controller: controller,
        onPageChanged: (i) => setState(() => index = i),
        children: <Widget>[
          HomePage(),
          Center(child: Text('Search Page')),
          Center(child: Text('More Page')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/home_page/home_page.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  int _currentIndex = 0;
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _controller.jumpToPage(index);
          });
        },
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
              icon: Icon(Icons.file_download),
              activeIcon: Icon(Icons.file_download),
              title: Text("Download")),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              activeIcon: Icon(Icons.list),
              title: Text("More")),
        ],
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          HomePage(),
          Center(child: Text('Search Page')),
          Center(child: Text('Download Page')),
          Center(child: Text('More Page')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// 页面加载数据时显示的loading page
class HttpLoadingPage extends StatelessWidget {
  const HttpLoadingPage({
    Key key,
    this.title = "Loading...",
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

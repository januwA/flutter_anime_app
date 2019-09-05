import 'package:flutter/material.dart';

class HttpErrorPage extends StatelessWidget {
  HttpErrorPage({
    Key key,
    this.title = "Error Page",
    this.body = const Center(child: Text('Error: 未知错误!!')),
  }) : super(key: key);

  /// appbar title
  final String title;

  /// 展示的错误信息
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
    );
  }
}

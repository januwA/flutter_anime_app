import 'package:flutter/material.dart';
import 'package:anime_app/shared/globals.dart';
import 'package:anime_app/utils/open_browser.dart';

class NotFoundPage extends StatefulWidget {
  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('not found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('页面丢失.'),
            FlatButton(
              child: Text('提交问题'),
              onPressed: () => openBrowser(githubIssuesUrl),
            ),
          ],
        ),
      ),
    );
  }
}

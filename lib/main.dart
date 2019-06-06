import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/dash_page/dash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashPage(),
    );
  }
}

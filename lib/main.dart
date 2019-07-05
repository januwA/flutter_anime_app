import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/dash/dash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Anime",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DashPage(),
    );
  }
}

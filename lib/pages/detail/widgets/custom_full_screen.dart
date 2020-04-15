import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_box/video_box.dart';

class VideoBoxFullScreenPage extends StatelessWidget {
  final controller;

  const VideoBoxFullScreenPage({Key key, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return Scaffold(
      body: Center(child: VideoBox(controller: controller)),
    );
  }
}

class MyCustomFullScreen extends CustomFullScreen {
  const MyCustomFullScreen();

  @override
  void close(BuildContext context, VideoController controller) {
    Navigator.of(context).pop();
  }

  Route<T> _route<T>(VideoController controller) {
    return MaterialPageRoute<T>(
      builder: (_) => VideoBoxFullScreenPage(controller: controller),
    );
  }

  @override
  Future<Object> open(BuildContext context, VideoController controller) async {
    SystemChrome.setEnabledSystemUIOverlays([]);
    await Navigator.of(context).push(_route(controller));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return null;
  }
}

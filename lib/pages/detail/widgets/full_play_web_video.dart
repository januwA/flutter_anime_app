import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sensors/sensors.dart';

/// 全屏播放嵌入的iframe视频
class FullPlayWebVideo extends StatefulWidget {
  final String initialUrl;

  const FullPlayWebVideo({Key key, this.initialUrl}) : super(key: key);
  @override
  _FullPlayWebVideoState createState() => _FullPlayWebVideoState();
}

class _FullPlayWebVideoState extends State<FullPlayWebVideo> {
  StreamSubscription<dynamic> _streamSubscriptions;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]); // 隐藏系统ui
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    _streamSubscriptions =
        accelerometerEvents.listen((AccelerometerEvent event) {
      // 横
      if (event.x > 1) {
        // left
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
      } else if (event.x < -1) {
        // right
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight]);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
    _streamSubscriptions.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: WebView(
            initialUrl: widget.initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (request) => NavigationDecision.prevent,
          ),
        ),
      ),
    );
  }
}

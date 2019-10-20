import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 全屏播放嵌入的iframe视频
class FullPlayWebVideo extends StatefulWidget {
  final String initialUrl;

  const FullPlayWebVideo({Key key, this.initialUrl}) : super(key: key);
  @override
  _FullPlayWebVideoState createState() => _FullPlayWebVideoState();
}

class _FullPlayWebVideoState extends State<FullPlayWebVideo> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]); // 隐藏系统ui
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            height: size.height,
            width: size.width,
            child: WebView(
              initialUrl: widget.initialUrl,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) {
                return NavigationDecision.prevent;
              },
            ),
          ),
        ),
      ),
    );
  }
}

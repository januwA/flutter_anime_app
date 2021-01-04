import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rxdart/rxdart.dart';

/// 移除页面广告的js脚本
String jsStr = """

function getPV(el, prop) {
  return document.defaultView
    .getComputedStyle(el, null)
    .getPropertyValue(prop);
}


function removePopUpsEvent() {
  let allElement = document.body.querySelectorAll("*");
  for (let i = 0; i < allElement.length; i++) {
    const el = allElement[i];
    if (
      el.classList.contains("ff-ads")
    ) {
      el.remove();
    }
    const position = getPV(el, "position");
    const zIndex = getPV(el, "z-index");

    if (
      position === "static" ||
      !Number.isFinite(Number(zIndex)) ||
      !zIndex ||
      zIndex < 2000
    ) {
      continue;
    }
    el.remove();
  }
}
let setIntervalCtrl;
function startRemovePopUpsEvent() {
  removePopUpsEvent();
  setIntervalCtrl = setInterval(removePopUpsEvent, 1000 * 2.5);
}
startRemovePopUpsEvent();
for (var i = 1; i < 200; i++) {
  clearInterval(i);
}
""";

class NicotvPage extends StatefulWidget {
  final String url;

  const NicotvPage({Key key, this.url = 'http://www.nicotv.me'})
      : super(key: key);
  @override
  NnicotvPageState createState() => NnicotvPageState();
}

class NnicotvPageState extends State<NicotvPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final title$ = BehaviorSubject<String>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            stream: title$.stream,
            initialData: "",
            builder: (context, snapshot) =>
                Text(snapshot.hasData ? snapshot.data : 'loading...')),
        actions: <Widget>[NavigationControls(_controller.future)],
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onPageFinished: (String url) async {
          try {
            var c = await _controller.future;
            String t = await c?.evaluateJavascript('document.title');
            title$.add(t);
            c?.evaluateJavascript(jsStr);
          } catch (_) {}
        },
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: (context, snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            ///  后退
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No back history item")),
                        );
                        return;
                      }
                    },
            ),

            /// 前进
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        controller.goForward();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("No forward history item")),
                        );
                        return;
                      }
                    },
            ),

            /// reload
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}

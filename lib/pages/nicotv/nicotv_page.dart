import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rxdart/rxdart.dart';

String jsStr = """
function getPV(el, prop) {
  return document.defaultView.getComputedStyle(el, null).getPropertyValue(prop);
}

function removePopUpsEvent() {
  let allElement = document.body.querySelectorAll("*");
  for (let i = 0; i < allElement.length; i++) {
    const el = allElement[i];
    if (el.classList.contains("ff-ads")) {
      el.remove();
    }
    const position = getPV(el, "position");
    const zIndex = getPV(el, "z-index");

    if (
      position === "static" ||
      !Number.isFinite(Number(zIndex)) ||
      !zIndex ||
      zIndex < 10000
    ) {
      continue;
    }
    el.remove();
  }
}

function startRemovePopUpsEvent() {
  removePopUpsEvent();
  setIntervalCtrl = setInterval(removePopUpsEvent, 1000*5);
}
startRemovePopUpsEvent();

""";

class NicotvPage extends StatefulWidget {
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
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData)
              return Text(snapshot.data);
            else
              return Text('loading...');
          },
        ),
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: Builder(
        builder: (context) {
          return WebView(
            initialUrl: 'http://www.nicotv.me',
            javascriptMode: JavascriptMode.unrestricted,

            /// 如果在创建Web视图后未调用null。
            /// 视图创建完毕
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },

            /// 可以在Web视图中运行的JavaScript代码的[JavascriptChannel]集合。
            // javascriptChannels: <JavascriptChannel>[
            //   _toasterJavascriptChannel(context),
            // ].toSet(),

            /// 委托函数，用于决定如何处理导航操作。
            // navigationDelegate: (NavigationRequest request) {
            //   if (request.url.startsWith('https://www.youtube.com/')) {
            //     print('阻止导航到 $request}');
            //     // 防止导航发生
            //     return NavigationDecision.prevent;
            //   }
            //   print('允许导航到 $request');
            //   return NavigationDecision.navigate;
            // },

            /// 页面加载完成后调用。
            onPageFinished: (String url) async {
              print('Page finished loading: $url');

              var c = await _controller.future;
              String t = await c.evaluateJavascript('document.title');
              title$.add(t);
              await c.evaluateJavascript(jsStr);
            },

            /// Web视图应使用哪些手势。
            // gestureRecognizers: null,
          );
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
                        Scaffold.of(context).showSnackBar(
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
                        Scaffold.of(context).showSnackBar(
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

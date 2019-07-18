import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/detail/detail.store.dart';
import 'package:flutter_video_app/shared/widgets/http_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum MenuOptions {
  openInBrowser,
  collections,
}

class DetailPage extends StatefulWidget {
  DetailPage({
    Key key,
    @required this.animeId,
  }) : super(key: key);

  /// anime的id
  final String animeId;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  DetailStore store = DetailStore();

  @override
  void initState() {
    super.initState();
    store.initState(this, widget.animeId);
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (store.loading) {
          return HttpLoadingPage(
            title: '加载中...',
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(store.detailData.videoName),
            actions: _buildActions(),
          ),
          body: ListView(
            children: <Widget>[
              Observer(
                builder: (_) => store.haokanBaidu
                    ? Hero(
                        tag: store.detailData.videoName,
                        child: store.video == null
                            ? Image.network(
                                store.detailData.cover,
                                fit: BoxFit.fill,
                              )
                            : store.video.videoBox)
                    : Container(
                        height: 220,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: WebView(
                            initialUrl: store.iframe.isEmpty
                                ? 'data:text/html,<h4>Loading...<h4>'
                                : store.iframeUrl,
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated:
                                (WebViewController webViewController) {
                              store.webviewController.add(webViewController);
                            },
                          ),
                        ),
                      ),
              ),
              _detailInfo(),
              ExpansionTile(
                title: Text(
                  store.detailData.plot,
                  overflow: TextOverflow.ellipsis,
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(store.detailData.plot),
                  ),
                ],
              ),
              Container(
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Theme.of(context).primaryColor,
                  controller: store.tabController,
                  tabs: store.detailData.tabs
                      .map<Widget>((el) => Tab(child: Text(el)))
                      .toList(),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                child: TabBarView(
                  controller: store.tabController,
                  children: <Widget>[
                    for (var tv in store.detailData.tabsValues)
                      ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          for (var t in tv.tabs)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: RaisedButton(
                                color: t == store.currentPlayVideo
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300],
                                onPressed: () => store.tabClick(t, context),
                                child: Text(t.text),
                              ),
                            ),
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      Builder(
        builder: (context) => PopupMenuButton(
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.openInBrowser:
                store.openInWebview(context);
                break;
              case MenuOptions.collections:
                store.collections(context);
                break;
              default:
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<MenuOptions>>[
            PopupMenuItem(
              value: MenuOptions.openInBrowser,
              child: ListTile(
                  leading: Icon(Icons.open_in_new), title: Text('浏览器打开')),
            ),
            PopupMenuItem(
              value: MenuOptions.collections,
              child: ListTile(
                  leading: Icon(Icons.collections),
                  title: Text(!store.isCollections ? '收藏' : '取消收藏')),
            ),
          ],
        ),
      ),
    ];
  }

  _detailInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text.rich(
            TextSpan(
              text: '${store.detailData.videoName}',
              style: Theme.of(context).textTheme.title,
              children: <TextSpan>[
                TextSpan(
                    text: '${store.detailData.curentText}',
                    style: Theme.of(context).textTheme.subtitle),
              ],
            ),
          ),
          Wrap(
            children: <Widget>[
              Text('主演:'),
              for (String name in store.detailData.starring)
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(name)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('导演:'),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(store.detailData.director)),
            ],
          ),
          Wrap(
            children: <Widget>[
              Text('类型:'),
              for (String name in store.detailData.types)
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(name)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('地区:'),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(store.detailData.area)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('年份:'),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(store.detailData.years)),
            ],
          ),
        ],
      ),
    );
  }
}

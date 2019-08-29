import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/pages/detail/detail.store.dart';
import 'package:flutter_video_app/pages/detail/menu_options.dart';
import 'package:flutter_video_app/shared/widgets/http_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  final double _appBarHeight = 220.0;

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

  _imagePlaceholder() {
    double width = double.infinity;
    double height = width;

    return Stack(
      children: <Widget>[
        Image.network(
          store.detail.cover,
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            width: width,
            height: height,
          ),
        ),
        Center(
          child: Image.network(
            store.detail.cover,
            fit: BoxFit.contain,
          ),
        )
      ],
    );
  }

  _webVideo() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
      child: Center(
        child: StreamBuilder<String>(
          stream: store.iframeVideo,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.active &&
                snap.data.isNotEmpty) {
              return Center(
                child: WebView(
                    initialUrl: snap.data,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController wc) {
                      wc.loadUrl(snap.data);
                    }),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
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
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: _appBarHeight,
                pinned: true,
                elevation: 0.0,
                actions: _buildActions(),
                flexibleSpace: store.haokanBaidu && mounted
                    ? store.video == null
                        ? FlexibleSpaceBar(
                            background: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Hero(
                                  tag: store.detail.cover,
                                  child: _imagePlaceholder(),
                                ),
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.0, -1.0),
                                      end: Alignment(0.0, -0.4),
                                      colors: <Color>[
                                        Color(0x60000000),
                                        Color(0x00000000)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(child: store.video.videoBox)
                    : _webVideo(),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _detailInfo(),
                    Card(
                      child: ExpansionTile(
                        title: Text(
                          store.detail.plot,
                          overflow: TextOverflow.ellipsis,
                        ),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(store.detail.plot),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: TabBar(
                              isScrollable: true,
                              unselectedLabelColor: Colors.grey,
                              labelColor: Theme.of(context).primaryColor,
                              controller: store.tabController,
                              tabs: store.detail.tabs
                                  .map<Widget>((el) => Tab(child: Text(el)))
                                  .toList(),
                            ),
                          ),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 12.0),
                            child: TabBarView(
                              controller: store.tabController,
                              children: <Widget>[
                                for (var tv in store.detail.tabsValues)
                                  ListView(
                                    // keep scroll offset
                                    key: PageStorageKey(tv),
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      for (var t in tv.tabs)
                                        _buildRaisedButton(t, context),
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildRaisedButton(TabsValueDto t, BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isActive = t.text == store.currentPlayVideo?.text;
    ShapeBorder shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0));
    TextStyle style = TextStyle(
      fontSize: theme.textTheme.caption.fontSize,
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      padding: EdgeInsets.all(4.0),
      child: isActive
          ? RaisedButton(
              shape: shape,
              textTheme: ButtonTextTheme.primary,
              color: theme.primaryColor,
              onPressed: () => store.tabClick(t, context),
              child: Text(
                t.text,
                style: style,
              ),
            )
          : OutlineButton(
              shape: shape,
              borderSide: BorderSide(
                color: theme.primaryColor,
              ),
              textTheme: ButtonTextTheme.primary,
              onPressed: () => store.tabClick(t, context),
              child: Text(t.text, style: style),
            ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DefaultTextStyle(
          style: TextStyle(
            inherit: true,
            fontSize: 14,
            color: Colors.black87,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: store.detail.videoName,
                child: Text(
                  store.detail.videoName,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                store.detail.curentText,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text('主演:'),
                  for (String name in store.detail.starring)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(name),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('导演:'),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(store.detail.director)),
                ],
              ),
              Wrap(
                children: <Widget>[
                  Text('类型:'),
                  for (String name in store.detail.types)
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
                      child: Text(store.detail.area)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('年份:'),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(store.detail.years)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

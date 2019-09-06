import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/pages/detail/detail.store.dart';
import 'package:flutter_video_app/shared/widgets/column_button.dart';
import 'package:flutter_video_app/shared/widgets/http_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/shared/widgets/network_image_placeholder.dart';
import 'package:video_box/video_box.dart';
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

class _DetailPageState extends State<DetailPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  DetailStore store = DetailStore();

  @override
  void initState() {
    super.initState();
    store.initState(
      this,
      context,
      widget.animeId,
    );

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    store.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('应用程序可见并响应用户输入。');
        break;
      case AppLifecycleState.inactive:
        print('应用程序处于非活动状态，并且未接收用户输入');
        break;
      case AppLifecycleState.paused:
        // 用户当前看不到应用程序，没有响应
        // 将应用至于后台时，保存下历史记录
        store.updateHistory();
        break;
      case AppLifecycleState.suspending:
        print('应用程序将暂停。');
        break;
      default:
    }
  }

  /// h5 video
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

  placeholderImage() {
    return Hero(
      tag: store.detail.cover,
      child: NetworkImagePlaceholder(store.detail.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (store.loading) {
          return HttpLoadingPage(title: '加载中...');
        }
        return SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: store.haokanBaidu && mounted
                            ? store.vc == null
                                ? placeholderImage()
                                : AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: VideoBox(
                                      controller: store.vc,
                                    ),
                                  )
                            : _webVideo(),
                      ),
                      Card(
                        child: Column(
                          children: <Widget>[
                            _detailInfo(),
                            _buildButtonBar(context),
                            ExpansionTile(
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
                              margin:
                                  const EdgeInsets.symmetric(vertical: 12.0),
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
          ),
        );
      },
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        ColumnButton(
          onPressed: () => store.collections(context),
          icon: Icon(
            Icons.collections,
            color: store.isCollections ? Colors.blue : Colors.black45,
          ),
          label: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '收藏',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        ColumnButton(
          onPressed: () => store.openInWebview(context),
          icon: Icon(Icons.open_in_new),
          label: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '浏览器',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
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

  _detailInfo() {
    Widget br = SizedBox(height: 4);
    return Padding(
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
            br,
            Text(
              store.detail.curentText,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            br,
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: <Widget>[
                Text('主演:'),
                for (String name in store.detail.starring) Text(name),
              ],
            ),
            br,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('导演:'),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(store.detail.director)),
              ],
            ),
            br,
            Wrap(
              children: <Widget>[
                Text('类型:'),
                for (String name in store.detail.types)
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(name)),
              ],
            ),
            br,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('地区:'),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(store.detail.area)),
              ],
            ),
            br,
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
    );
  }
}

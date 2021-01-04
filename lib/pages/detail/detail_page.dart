import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';
import 'package:flutter_video_app/pages/detail/detail.store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_app/pages/detail/widgets/source_button.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_video_app/utils/open_browser.dart';
import 'package:video_box/video_box.dart';

import 'package:flutter_video_app/service/nicotv.service.dart';
import 'widgets/detail_text.dart';
import 'widgets/network_image_placeholder.dart';
import 'widgets/video_bar.dart';
import 'widgets/wrap_text.dart';

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
  var store = DetailStore();

  @override
  void initState() {
    super.initState();
    store.initState(this, context, widget.animeId);
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
        // 应用程序可见并响应用户输入
        break;
      case AppLifecycleState.inactive:
        // 应用程序处于非活动状态，并且未接收用户输入
        store.pip();
        break;
      case AppLifecycleState.paused:
        // 用户当前看不到应用程序，没有响应
        // 将应用至于后台时，保存下历史记录
        store.updateHistory();
        break;
      case AppLifecycleState.detached:
        // 应用程序将暂停
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Observer(
        builder: (context) => Scaffold(
          body: store.loading
              ? Center(child: CircularProgressIndicator())
              : Platform.isWindows
                  ? Scaffold(
                      appBar: AppBar(title: Text(store.detail.videoName)),
                      body: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 1200,
                          ),
                          child: _body(),
                        ),
                      ),
                    )
                  : Scaffold(body: _body()),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (Platform.isAndroid || Platform.isIOS)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _createVideoBox(),
          ),
        Expanded(
          child: CupertinoScrollbar(
            child: ListView(
              controller: store.controller,
              children: <Widget>[
                if (Platform.isWindows)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _createVideoBox(),
                  ),

                // 信息区
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _detailInfo(),
                        SizedBox(height: 8),
                        DetailText(store.detail.plot),
                      ],
                    ),
                  ),
                ),

                // 资源区
                Card(
                  child: Column(
                    children: <Widget>[
                      _createTabbar(),
                      Container(
                        height: 90,
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        child: TabBarView(
                          controller: store.tabController,
                          children: <Widget>[
                            for (var tv in store.detail.tabsValues)
                              _createTabBarViewItem(tv),
                            _otherOpenMethods(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ...store.detail.listUnstyled.map((ListUnstyledItem item) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                store.detail.listUnstyledTitle[
                                    store.detail.listUnstyled.indexOf(item)],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            itemCount: item.item.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              var anime = item.item[index];
                              return AspectRatio(
                                aspectRatio: AnimeCard.aspectRatio,
                                child: AnimeCard(
                                  key: ValueKey(anime.id),
                                  animeData: anime,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 播放类型tabbar
  Widget _createTabbar() {
    var theme = Theme.of(context);
    final tabs = store.detail.tabs.toList();
    tabs.add('其他方式打开');
    return Container(
      color: theme.primaryColor,
      width: double.infinity,
      child: TabBar(
        isScrollable: true,
        controller: store.tabController,
        indicatorColor: Colors.white,
        tabs: tabs.map<Widget>((el) => Tab(child: Text(el))).toList(),
      ),
    );
  }

  Widget _otherOpenMethods() {
    final name = Uri.encodeComponent(store.detail.videoName);
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Center(
          child: SourceButton(
            child: Text('bilibili App'),
            onPressed: () =>
                openBrowser('bilibili://search?keyword=$name', context),
          ),
        ),
        Center(
          child: SourceButton(
            child: Text('bilibili'),
            onPressed: () => openBrowser(
                'https://search.bilibili.com/bangumi?keyword=$name', context),
          ),
        ),
        Center(
          child: SourceButton(
            child: Text('dilidili3'),
            onPressed: () => openBrowser(
                'http://www.dilidili3.com/public/api.php?app=video&do=search&q=$name',
                context),
          ),
        ),
        Center(
          child: SourceButton(
            child: Text('youku'),
            onPressed: () => openBrowser(
                'https://so.youku.com/search_video/q_$name?searchfrom=1',
                context),
          ),
        ),
        // Center(
        //   child: SourceButton(
        //     child: Text('源地址'),
        //     onPressed: () => openBrowser(
        //         'http://www.nicotv.me/video/detail/${store.animeId}.html'),
        //   ),
        // ),
      ],
    );
  }

  Widget _createTabBarViewItem(TabsDto tv) {
    var theme = Theme.of(context);
    return Builder(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('选集')),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('选集 (${tv.tabs.length})'),
                                      IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                    children: <Widget>[
                                      Center(
                                        child: Observer(
                                          builder: (_) => Wrap(
                                            alignment: WrapAlignment.start,
                                            children: tv.tabs
                                                .map((e) => _buildSouceButton(
                                                    e, context))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Text(
                    '共 ${tv.tabs.length} 集',
                    style: theme.textTheme.caption,
                  ),
                ),
                Icon(
                  Icons.arrow_right,
                  color: theme.textTheme.caption.color,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              key: PageStorageKey(tv),
              scrollDirection: Axis.horizontal,
              children:
                  tv.tabs.map((e) => _buildSouceButton(e, context)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 播放时显示video，反之显示占位图像
  Widget _createVideoBox() {
    return store.currentPlayVideo != null &&
                store.animeVideoType == AnimeVideoType.mp4 ||
            store.animeVideoType == AnimeVideoType.m3u8 && mounted
        ? Observer(
            builder: (_) => SizedBox(
              child: VideoBox(
                controller: store.vc,
                children: _videoBoxChildren(),
              ),
            ),
          )
        : NetworkImagePlaceholder(store.detail.cover);
  }

  /// prev and next button
  List<Widget> _videoBoxChildren() {
    const Color disabledColor = Colors.white60;
    return [
      VideoBar(store: store),
      Observer(
        builder: (_) => Align(
          alignment: Alignment(-0.5, 0),
          child: IconButton(
            iconSize: VideoBox.centerIconSize,
            disabledColor: disabledColor,
            icon: Icon(Icons.skip_previous),
            onPressed: store.canPrevPlay ? () => store.prevPlay(context) : null,
          ),
        ),
      ),
      Observer(
        builder: (_) => Align(
          alignment: Alignment(0.5, 0),
          child: IconButton(
            iconSize: VideoBox.centerIconSize,
            disabledColor: disabledColor,
            icon: Icon(Icons.skip_next),
            onPressed: store.canNextPlay ? () => store.nextPlay(context) : null,
          ),
        ),
      ),
    ];
  }

  Widget _buildSouceButton(TabsValueDto t, BuildContext context) {
    return SourceButton(
      isActive: t.text == store.currentPlayVideo?.text,
      onPressed: () => store.tabClick(t, context),
      child: Text(
        t.text,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.caption.fontSize,
        ),
      ),
    );
  }

  Widget _detailInfo() {
    Widget br = const SizedBox(height: 4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SelectableText(
          store.detail.videoName,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        br,
        SelectableText(
          store.detail.curentText,
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 8),
        WrapText(
          tag: '主演:',
          texts: store.detail.starring.toList(),
        ),
        br,
        WrapText(
          tag: '导演:',
          texts: [store.detail.director],
        ),
        br,
        WrapText(
          tag: '类型:',
          texts: store.detail.types.toList(),
        ),
        br,
        WrapText(
          tag: '地区:',
          texts: [store.detail.area],
        ),
        br,
        WrapText(
          tag: '年份:',
          texts: [store.detail.years],
        ),
      ],
    );
  }
}

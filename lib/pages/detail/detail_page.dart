import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/models/detail_data_dto/detail_data_dto.dart';
import 'package:flutter_video_app/pages/detail/detail.store.dart';
import 'package:flutter_video_app/shared/widgets/alert_http_get_error.dart';
import 'package:flutter_video_app/shared/widgets/http_error_page.dart';
import 'package:flutter_video_app/shared/widgets/http_loading_page.dart';
import 'package:flutter_video_app/shared/widgets/video_box/video.dart';
import 'package:validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

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

class _DetailPageState extends State<DetailPage> {
  DetailStore detailStore;

  @override
  void initState() {
    super.initState();
    detailStore = DetailStore(animeId: widget.animeId);
  }

  @override
  void dispose() {
    detailStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!isNull(detailStore.weekDataerror)) {
          return HttpErrorPage(
            body: Text(detailStore.weekDataerror),
          );
        }

        if (detailStore.isPageLoading) {
          return HttpLoadingPage(
            title: '加载中...',
          );
        }

        return MultiProvider(
          providers: [Provider<DetailStore>.value(value: detailStore)],
          child: Scaffold(
            appBar: AppBar(
              title: Text(detailStore.detailData.videoName),
            ),
            body: ListView(
              children: <Widget>[
                Observer(
                  builder: (_) => VideoBox(src: detailStore.src),
                ),

                /// anime的信息资料
                DetailInfo(),

                /// anime 剧情介绍
                ExpansionTile(
                  title: Text(
                    detailStore.detailData.plot,
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(detailStore.detailData.plot),
                    ),
                  ],
                ),

                /// 每集的tab
                Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (PlayUrlTab t in detailStore.detailData.playUrlTab)
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: PlayTab(t: t)),
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
}

class PlayTab extends StatelessWidget {
  PlayTab({Key key, this.t}) : super(key: key);
  final PlayUrlTab t;
  @override
  Widget build(BuildContext context) {
    final detailStore = Provider.of<DetailStore>(context);
    var index = detailStore.detailData.playUrlTab.indexOf(t);
    return Observer(
      builder: (_) => FlatButton(
            color: index == detailStore.currentPlayIndex
                ? Colors.blue[400]
                : Colors.grey[300],
            child: Text(t.text),
            onPressed: () async {
              if (t.isBox) {
                // 网盘资源
                if (await canLaunch(t.src)) {
                  await launch(t.src);
                } else {
                  throw 'Could not launch ${t.src}';
                }
              } else {
                detailStore.setSrc('');
                // 视频资源,准备切换播放点击的视频
                detailStore.setCurrentPlayIndex(index);
                detailStore.getVideoSrc(() {
                  alertHttpGetError(
                    context: context,
                    title: '提示',
                    text: detailStore.videoSrcerror,
                    okText: '确定',
                  );
                });
              }
            },
          ),
    );
  }
}

class DetailInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detailData = Provider.of<DetailStore>(context).detailData;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text.rich(
            TextSpan(
              text: '${detailData.videoName}',
              style: Theme.of(context).textTheme.title,
              children: <TextSpan>[
                TextSpan(
                    text: '${detailData.curentText}',
                    style: Theme.of(context).textTheme.subtitle),
              ],
            ),
          ),
          Wrap(
            children: <Widget>[
              Text('主演:'),
              for (String name in detailData.starring)
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
                  child: Text(detailData.director)),
            ],
          ),
          Wrap(
            children: <Widget>[
              Text('类型:'),
              for (String name in detailData.types)
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
                  child: Text(detailData.area)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('年份:'),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(detailData.years)),
            ],
          ),
        ],
      ),
    );
  }
}

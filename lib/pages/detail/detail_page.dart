import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/models/detail_data_dto/detail_data_dto.dart';
import 'package:flutter_video_app/pages/detail/detail.store.dart';
import 'package:flutter_video_app/shared/widgets/alert_http_get_error.dart';
import 'package:flutter_video_app/shared/widgets/http_error_page.dart';
import 'package:flutter_video_app/shared/widgets/http_loading_page.dart';
import 'package:validators/validators.dart';
import 'package:video_player/video_player.dart';
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
        if (detailStore.isFullScreen) {
          return SafeArea(
            child: Scaffold(
              body: MultiProvider(
                providers: [Provider<DetailStore>.value(value: detailStore)],
                child: VideoBox(),
              ),
            ),
          );
        }

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
                VideoBox(),

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
                // 视频资源,准备切换播放点击的视频
                detailStore.setCurrentPlayIndex(index);
                detailStore.showVideoCtrl(true);
                detailStore.videoCtrl.pause();
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

/// video+controller 容器盒子
class VideoBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detailStore = Provider.of<DetailStore>(context);

    return Observer(
      builder: (_) => GestureDetector(
            onTap: () =>
                detailStore.showVideoCtrl(!detailStore.isShowVideoCtrl),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                detailStore.isVideoLoading
                    ? VideoLoading()
                    : Container(
                        color: Colors.black,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio:
                                detailStore.videoCtrl.value.aspectRatio,
                            child: VideoPlayer(detailStore.videoCtrl),
                          ),
                        ),
                      ),
                Observer(
                  builder: (_) => playButton(detailStore),
                ),
                Observer(
                  builder: (_) => videoBottomCtrl(detailStore),
                ),
              ],
            ),
          ),
    );
  }

  Positioned videoBottomCtrl(DetailStore detailStore) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 300),
        firstChild: Container(),
        secondChild: Container(
          decoration: BoxDecoration(color: Colors.black12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Text(
                  detailStore.isVideoLoading
                      ? '00:00/00:00'
                      : "${detailStore.positionText}/${detailStore.durationText}",
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: Slider(
                    inactiveColor: Colors.grey,
                    activeColor: Colors.white,
                    value: detailStore.sliderValue,
                    onChanged: detailStore.seekTo,
                  ),
                ),
                detailStore.isVideoLoading
                    ? IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.volume_up),
                        onPressed: () {},
                      )
                    : IconButton(
                        color: Colors.white,
                        icon: Icon(
                          detailStore.videoCtrl.value.volume <= 0
                              ? Icons.volume_off
                              : Icons.volume_up,
                        ),
                        onPressed: detailStore.setVolume,
                      ),
                IconButton(
                  icon: Icon(
                    !detailStore.isFullScreen
                        ? Icons.fullscreen
                        : Icons.fullscreen_exit,
                    color: Colors.white,
                  ),
                  onPressed: detailStore.onFullScreen,
                ),
              ],
            ),
          ),
        ),
        crossFadeState: detailStore.isShowVideoCtrl
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
      ),
    );
  }

  AnimatedCrossFade playButton(DetailStore detailStore) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: Container(),
      secondChild: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          color: Colors.black,
          icon: Icon(
            detailStore.videoCtrl.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
          onPressed: detailStore.togglePlay,
        ),
      ),
      crossFadeState: detailStore.isShowVideoCtrl
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}

class VideoLoading extends StatelessWidget {
  const VideoLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            )
          ],
        ),
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

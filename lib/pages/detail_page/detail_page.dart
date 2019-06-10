import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_video_app/models/detail.dto.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  DetailPage({
    Key key,
    @required this.id,
  }) : super(key: key);
  final String id;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  /// 页面数据
  DetailDto detailData;
  List<PlayUrlTab> get videos =>
      detailData == null ? List<PlayUrlTab>() : detailData.playUrlTab;
  Client _client;
  VideoPlayerController videoCtrl;

  /// 当前播放位置
  int currentPlayIndex = 0;

  /// 当前播放的视频
  PlayUrlTab get currentPlayVideo => videos[currentPlayIndex];

  /// 页面状态

  bool isPageLoading = false;
  bool isGetSrcLoading = false;

  /// 当前时长
  Duration position;

  /// 总时长
  Duration duration;

  /// 是否显示控制器
  /// 播放 false
  /// 暂停 true
  bool isShowVideoControllers = true;

  /// 是否为全屏播放
  bool _isFullScreen = false;

  /// 是否为播放状态
  bool get isPlaying => videoCtrl.value.isPlaying;

  /// 00:01 当前时间
  String get durationText {
    if (duration == null) return '';
    var r = duration.toString().split('.').first.split(':')..removeAt(0);
    return r.join(':');
  }

  /// 25:00 总时长
  String get positionText {
    if (position == null) return '';
    var r = position.toString().split('.').first.split(':')..removeAt(0);
    return r.join(':');
  }

  double get sliderValue {
    if (position?.inSeconds != null && duration?.inSeconds != null) {
      return position.inSeconds / duration.inSeconds;
    } else {
      return 0.0;
    }
  }

  @override
  void initState() {
    super.initState();
    this.getDetailData();
  }

  @override
  void dispose() {
    super.dispose();
    _client?.close();
  }

  /// 获取http数据
  Future<void> getDetailData() async {
    setState(() {
      isPageLoading = true;
    });
    try {
      _client = http.Client();
      var url = Uri.http('192.168.56.1:3000', "/detail", {"id": widget.id});
      var r = await _client.get(url);
      setState(() {
        detailData = DetailDto.fromJson(jsonDecode(r.body)['data']);
        isPageLoading = false;
      });

      _initVideoPlaer();
    } catch (e) {
      print(e);
    }
  }

  _getVideoSrc() async {
    if (videos.isEmpty) return false;
    var i = videos[currentPlayIndex];
    if (i.isBox || i.src.isNotEmpty) {
      /// 网盘资源,已经有src的 不做处理
    } else {
      setState(() {
        isGetSrcLoading = true;
      });
      var url = Uri.http('192.168.56.1:3000', "/src", {"id": i.id});
      var r = await _client.get(url);
      print(r.body);
      setState(() {
        detailData.playUrlTab[currentPlayIndex].src = r.body;
        isGetSrcLoading = false;
      });
      _initVideoPlaer();
    }
  }

  /// 初始化viedo控制器
  void _initVideoPlaer() {
    videoCtrl = VideoPlayerController.network(currentPlayVideo.src)
      ..initialize().then((_) {
        setState(() {
          position = Duration(seconds: 0);
          duration = videoCtrl.value.duration;
        });
        videoCtrl.addListener(() {
          // 监听播放时
        });
      });
    videoCtrl.setVolume(1.0);
  }

  /// 设置为横屏模式
  _setLandscape() {
    setState(() {
      _isFullScreen = true;
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  /// 设置为正常模式
  _setPortrait() {
    setState(() {
      _isFullScreen = false;
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (isPageLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('数据加载中...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(detailData.videoName),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              // 暂停状态强制显示控制器
              if (!videoCtrl.value.isPlaying) return false;

              setState(() {
                isShowVideoControllers = !isShowVideoControllers;
              });

              if (isShowVideoControllers) {
                await Future.delayed(Duration(seconds: 2));
                setState(() {
                  isShowVideoControllers = false;
                });
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                if (videoCtrl?.value?.initialized || !isGetSrcLoading)
                  AspectRatio(
                    aspectRatio: videoCtrl.value.aspectRatio,
                    child: VideoPlayer(videoCtrl),
                  )
                else
                  AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                  ),
                AnimatedCrossFade(
                  duration: Duration(milliseconds: 300),
                  firstChild: Container(),
                  secondChild: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      color: Colors.black,
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        if (isPlaying) {
                          videoCtrl.pause();
                          setState(() {
                            isShowVideoControllers = true;
                          });
                        } else {
                          videoCtrl.play();
                          setState(() {
                            isShowVideoControllers = false;
                          });
                        }
                      },
                    ),
                  ),
                  crossFadeState: isShowVideoControllers
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedCrossFade(
                    duration: Duration(milliseconds: 300),
                    firstChild: Container(),
                    secondChild: Container(
                      decoration: BoxDecoration(color: Colors.black45),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        dense: true,
                        title: Row(
                          children: <Widget>[
                            Text(
                              "$positionText / $durationText",
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            SmallIconButton(
                              icon: Icon(
                                Icons.volume_up,
                                color: Colors.white,
                              ),
                              onTap: () {},
                            ),
                            SmallIconButton(
                              icon: Icon(
                                !_isFullScreen
                                    ? Icons.fullscreen
                                    : Icons.fullscreen_exit,
                                color: Colors.white,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                        subtitle: Slider(
                          inactiveColor: Colors.grey,
                          value: sliderValue,
                          onChanged: (v) {
                            videoCtrl.seekTo(Duration(seconds: v.toInt()));
                          },
                        ),
                      ),
                    ),
                    crossFadeState: isShowVideoControllers
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ),
              ],
            ),
          ),
          DetailInfo(detailData: detailData),
          ExpansionTile(
            title: Text(
              detailData.plot,
              overflow: TextOverflow.ellipsis,
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(detailData.plot),
              ),
            ],
          ),
          Center(
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[for (PlayUrlTab t in videos) _playTab(t)],
            ),
          ),
        ],
      ),
    );
  }

  _onFullScreen() {
    if (!_isFullScreen) {
      _setLandscape();
    } else {
      _setPortrait();
    }
  }

  /// 每集 tab
  _playTab(PlayUrlTab t) {
    var index = videos.indexOf(t);
    return RaisedButton(
      color: index == currentPlayIndex ? Colors.blue[400] : Colors.grey[300],
      child: Text(t.text),
      onPressed: () async {
        if (t.isBox) {
          print('打开浏览器');
          if (await canLaunch(t.src)) {
            await launch(t.src);
          } else {
            throw 'Could not launch ${t.src}';
          }
        } else {
          print('播放视频资源');
          setState(() {
            currentPlayIndex = index;
            isShowVideoControllers = true;
          });
          videoCtrl.pause();
          videoCtrl.setVolume(0.0);
          _initVideoPlaer();
        }
      },
    );
  }
}

class DetailInfo extends StatelessWidget {
  const DetailInfo({
    Key key,
    @required this.detailData,
  }) : super(key: key);

  final detailData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("${detailData.videoName} ${detailData.curentText}"),
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

/// 全屏播放video时需要的页面
// class FullScreenVideo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData deviceData = MediaQuery.of(context);
//     return SafeArea(
//       child: Scaffold(
//         body: SizedBox(
//           width: deviceData.size.width,
//           height: deviceData.size.height,
//           child: VideoBox(),
//         ),
//       ),
//     );
//   }
// }

/// video 控制器上的按钮
class SmallIconButton extends StatelessWidget {
  SmallIconButton({
    Key key,
    this.icon,
    this.onTap,
    this.padding = const EdgeInsets.all(4.0),
  }) : super(key: key);
  final Widget icon;
  final EdgeInsetsGeometry padding;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: icon,
      ),
    );
  }
}

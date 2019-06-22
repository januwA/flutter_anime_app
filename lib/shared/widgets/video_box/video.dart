import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/shared/widgets/video_box/video.store.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:video_player/video_player.dart';

/// video+controller 容器盒子
class VideoBox extends StatefulWidget {
  VideoBox({
    Key key,

    /// 网络播放地址
    this.src,
    this.store,
    this.isDispose = true,
  }) : super(key: key);

  final String src;
  final VideoStore store;
  final bool isDispose;
  @override
  _VideoBoxState createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
  VideoStore videoStore;

  @override
  void initState() {
    super.initState();
    videoStore = widget.store ?? VideoStore(src: widget.src);
  }

  @override
  void dispose() {
    if (widget.isDispose) {
      videoStore.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => isNull(videoStore.src)
          ? VideoLoading()
          : MultiProvider(
              providers: [Provider<VideoStore>.value(value: videoStore)],
              child: GestureDetector(
                onTap: () =>
                    videoStore.showVideoCtrl(!videoStore.isShowVideoCtrl),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    videoStore.isVideoLoading
                        ? VideoLoading()
                        : Container(
                            color: Colors.black,
                            child: Center(
                              child: AspectRatio(
                                aspectRatio:
                                    videoStore.videoCtrl.value.aspectRatio,
                                child: VideoPlayer(videoStore.videoCtrl),
                              ),
                            ),
                          ),
                    PlayButton(),
                    VideoBottomCtrl(),
                  ],
                ),
              ),
            ),
    );
  }
}

/// video 中间的播放按钮
class PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final videoStore = Provider.of<VideoStore>(context);
    return Observer(
      builder: (_) => AnimatedCrossFade(
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
                  videoStore.videoCtrl == null ||
                          videoStore.videoCtrl.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                onPressed: videoStore.togglePlay,
              ),
            ),
            crossFadeState: videoStore.isShowVideoCtrl
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
    );
  }
}

/// video 底部的控制器
class VideoBottomCtrl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final videoStore = Provider.of<VideoStore>(context);
    return Observer(
      builder: (_) => Positioned(
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
                        videoStore.isVideoLoading
                            ? '00:00/00:00'
                            : "${videoStore.positionText}/${videoStore.durationText}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Slider(
                          inactiveColor: Colors.grey[300],
                          activeColor: Colors.white,
                          value: videoStore.sliderValue,
                          onChanged: videoStore.seekTo,
                        ),
                      ),
                      videoStore.isVideoLoading
                          ? IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.volume_up),
                              onPressed: () {},
                            )
                          : IconButton(
                              color: Colors.white,
                              icon: Icon(
                                videoStore.videoCtrl.value.volume <= 0
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                              ),
                              onPressed: videoStore.setVolume,
                            ),
                      IconButton(
                        icon: Icon(
                          !videoStore.isFullScreen
                              ? Icons.fullscreen
                              : Icons.fullscreen_exit,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (videoStore.isFullScreen) {
                            /// 退出全屏
                            Navigator.of(context).pop();
                          } else {
                            /// 开启全屏
                            /// 改变屏幕方向，不销毁控制器
                            videoStore.setLandscape();
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => FullScreenVideo(
                                      videoStore: videoStore,
                                    )));

                            /// 用户结束了全屏
                            /// 按下icon或者手机返回键
                            videoStore.setPortrait();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              crossFadeState: videoStore.isShowVideoCtrl
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
    );
  }
}

/// 没有src的时候，显示加载中
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

/// 全屏播放view
class FullScreenVideo extends StatelessWidget {
  FullScreenVideo({this.videoStore});
  final VideoStore videoStore;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: VideoBox(
            store: videoStore,
            isDispose: false,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:anime_app/service/collections.service.dart';
import 'package:anime_app/service/playback_speed.service.dart';
import 'package:anime_app/sqflite_db/model/collection.dart';
import 'package:anime_app/utils/show_snackbar.dart';

import '../../../main.dart';
import '../detail.store.dart';

class VideoBar extends StatelessWidget {
  final DetailStore store;

  final playbackSpeedService = getIt<PlaybackSpeedService>();

  final collectionsService = getIt<CollectionsService>();

  final List<double> speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  VideoBar({Key key, @required this.store}) : super(key: key);

  /// 收藏 or 取消收藏
  void _collections(BuildContext context, bool _isColl) {
    if (!_isColl) {
      collectionsService.insertCollection(Collection(animeId: store.animeId));
      showSnackbar(context, '收藏成功 >_<');
    } else {
      collectionsService.deleteCollection(store.animeId);
      showSnackbar(context, '已取消收藏!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(store.detail.videoName) ?? SizedBox(),
        elevation: 0,
        actions: [
          // 收藏
          FutureBuilder(
            future: collectionsService.exist(store.animeId),
            builder: (context, AsyncSnapshot<bool> snap) {
              if (snap.connectionState == ConnectionState.done) {
                return IconButton(
                  icon: Icon(Icons.collections),
                  color: snap.data ? Colors.blue : Colors.white,
                  onPressed: () => _collections(context, snap.data),
                );
              }
              return SizedBox();
            },
          ),

          // options
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StreamBuilder<double>(
                          stream: playbackSpeedService.speed$,
                          builder: (context, snap) {
                            return ListTile(
                              leading: Icon(
                                Icons.slow_motion_video,
                                color: Colors.grey,
                              ),
                              title: Text(
                                '播放速度',
                              ),
                              onTap: () {
                                showModalBottomSheet<double>(
                                  context: context,
                                  builder: (context) {
                                    return ListView(
                                      children: speeds
                                          .map((e) => ListTile(
                                                dense: true,
                                                leading: snap.data == e
                                                    ? Icon(Icons.done,
                                                        color: Colors.grey)
                                                    : SizedBox(),
                                                title: Text('$e倍'),
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pop(e),
                                              ))
                                          .toList(),
                                    );
                                  },
                                ).then((value) {
                                  if (value != null)
                                    playbackSpeedService
                                        .setPlaybackSpeed(value);
                                  Navigator.of(context).pop();
                                });
                              },
                            );
                          }),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

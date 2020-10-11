import 'package:flutter/material.dart';

import '../detail.store.dart';

class VideoBar extends StatelessWidget {
  final DetailStore store;

  VideoBar({Key key, @required this.store}) : super(key: key);

  final List<double> speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
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
          IconButton(
            icon: Icon(Icons.collections),
            color: store.isCollections ? Colors.blue : Colors.white,
            onPressed: () => store.collections(context),
          ),

          // 浏览器打开
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: store.openInWebview,
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
                      ListTile(
                        leading: Icon(Icons.slow_motion_video),
                        title: Text('播放速度'),
                        onTap: () {
                          showModalBottomSheet<double>(
                            context: context,
                            builder: (context) {
                              return ListView(
                                children: speeds
                                    .map((e) => ListTile(
                                          title: Text(e.toString() + '倍'),
                                          onTap: () =>
                                              Navigator.of(context).pop(e),
                                        ))
                                    .toList(),
                              );
                            },
                          ).then((value) {
                            if (value != null) store.vc.setPlaybackSpeed(value);
                            Navigator.of(context).pop();
                          });
                        },
                      ),
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

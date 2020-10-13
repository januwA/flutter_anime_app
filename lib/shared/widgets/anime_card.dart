import 'package:flutter/material.dart';
import 'package:flutter_imagenetwork/flutter_imagenetwork.dart';
import 'package:flutter_video_app/dto/li_data/li_data.dart';
import 'package:flutter_video_app/router/router.dart';

/// 每个anime的展示卡片
class AnimeCard extends StatelessWidget {
  final LiData animeData;
  static const double aspectRatio = 0.72;
  AnimeCard({
    Key key,
    @required this.animeData,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toDerailPage,
      child: Card(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              // child: AjanuwImage(
              //   image: AjanuwNetworkImage(animeData.img),
              //   frameBuilder: AjanuwImage.defaultFrameBuilder,
              //   fit: BoxFit.fill,
              //   width: double.infinity,
              //   height: double.infinity,
              // ),
              child: Image.network(
                animeData.img,
                frameBuilder: AjanuwImage.defaultFrameBuilder,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            if (animeData.isNew)
              Opacity(
                opacity: .95,
                child: Image.asset('assets/new_ico.png', scale: 1.5),
              ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black54.withAlpha(10),
                      Colors.black54,
                    ],
                    begin: Alignment(0.0, -0.8),
                    end: Alignment(0.0, 1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      animeData.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      animeData.current,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _toDerailPage() {
    router.pushNamed('/anime-detail/${animeData.id}');
  }

  // _toNicotvPage() {
  //   String url = 'http://www.nicotv.me/video/detail/${animeData.id}.html';
  //   router.pushNamed('/nicotv', arguments: url);
  // }
}

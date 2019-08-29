import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/pages/detail/detail_page.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';

/// 每个anime的展示卡片
class AnimeCard extends StatelessWidget {
  AnimeCard({
    Key key,
    @required this.animeData,
  }) : super(key: key);
  static const double aspectRatio = 0.7;
  final LiData animeData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _toDerailPage(context),
      child: Card(
        child: Stack(
          children: [
            Hero(
              tag: animeData.img,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  animeData.img,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  color: Colors.green,
                  icon: Icon(Icons.open_in_new),
                  onPressed: () => _toNicotvPage(context),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, 0.3),
                  colors: [
                    Colors.black54.withAlpha(10),
                    Colors.black54,
                  ],
                )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: animeData.title,
                      child: Text(
                        animeData.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
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

  _toDerailPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetailPage(animeId: animeData.id)));
  }

  _toNicotvPage(BuildContext context) {
    String url = 'http://www.nicotv.me/video/detail/${animeData.id}.html';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NicotvPage(
          url: url,
        ),
      ),
    );
  }
}

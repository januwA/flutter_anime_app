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

  final LiData animeData;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPage(animeId: animeData.id))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Hero(
                    tag: animeData.img,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.network(
                        animeData.img,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    animeData.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(animeData.current),
                )
              ],
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
                onPressed: () {
                  String url =
                      'http://www.nicotv.me/video/detail/${animeData.id}.html';
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NicotvPage(
                            url: url,
                          )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

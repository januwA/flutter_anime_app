import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
import 'package:flutter_video_app/pages/detail/detail_page.dart';

/// 每个anime的展示卡片
class AnimeCard extends StatelessWidget {
  AnimeCard({
    @required this.animeData,
  });

  final LiData animeData;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(animeId: animeData.id))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  animeData.img,
                  fit: BoxFit.fill,
                  width: double.infinity,
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
    );
  }
}

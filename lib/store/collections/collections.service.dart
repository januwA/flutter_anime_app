import 'dart:convert';

import 'package:flutter_video_app/db/collections.moor.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:mobx/mobx.dart';
import 'package:html/dom.dart' as dom;
import 'package:moor/moor.dart';

part 'collections.service.g.dart';

class CollectionsService = _CollectionsService with _$CollectionsService;

/// 收藏
final String tablename = 'collections';

abstract class _CollectionsService with Store {
  CollectionDatabase _db = CollectionDatabase();
  CollectionDao get _collectionDao => _db.collectionDao;

  /// 收藏夹流
  Stream<List<Collection>> get collections$ =>
      _collectionDao.watchAllCollections();

  /// 根据 animeId获取数据
  Future<LiData> getAnime(String animeId) async {
    dom.Document document =
        await $document('http://www.nicotv.me/video/detail/$animeId.html');
    dom.Element mediaBody = $(document, '.media-body');
    return LiData.fromJson(
      jsonEncode(
        {
          "id": animeId,
          "title": $(mediaBody, 'h2 a').innerHtml.trim(),
          "img": $(document, '.media-left img').attributes['data-original'],
          "current": $(mediaBody, 'h2 small').innerHtml.trim(),
        },
      ),
    );
  }

  /// 检查是否在收藏夹内
  Future<bool> exist(String animeId) {
    return _collectionDao.exist(animeId);
  }

  /// 添加收藏
  Future<int> insertCollection(Insertable<Collection> collection) {
    return _collectionDao.insertCollection(collection);
  }

  /// 删除收藏
  Future<int> deleteCollection(String animeId) {
    return _collectionDao.deleteCollection(animeId);
  }
}

import 'package:flutter_video_app/db/app_database.dart';
import 'package:flutter_video_app/db/collections.table.dart';
import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/shared/nicotv.service.dart';
import 'package:mobx/mobx.dart';
import 'package:moor/moor.dart';

part 'collections.service.g.dart';

class CollectionsService = _CollectionsService with _$CollectionsService;

abstract class _CollectionsService with Store {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入
  AppDatabase _db = AppDatabase();
  CollectionDao get _collectionDao => _db.collectionDao;

  /// 收藏夹流
  Stream<List<Collection>> get collections$ =>
      _collectionDao.watchAllCollections();

  /// 根据 animeId获取数据
  Future<LiData> getAnime(String animeId) async {
    return nicoTvService.getAnimeInfo(animeId);
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

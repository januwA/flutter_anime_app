import 'package:flutter_video_app/dto/li_data/li_data.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/service/nicotv.service.dart';
import 'package:flutter_video_app/sqflite_db/model/collection.dart';
import 'package:flutter_video_app/sqflite_db/sqflite_db.dart';

class CollectionsService {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入
  // AppDatabase _db = AppDatabase();
  AnimeDB _db = AnimeDB();

  Future<List<Collection>> get collections {
    return _db.getAllCollections();
  }

  /// 根据 animeId获取数据
  Future<LiData> getAnime(String animeId) async {
    return nicoTvService.getAnimeInfo(animeId);
  }

  /// 检查是否在收藏夹内
  Future<bool> exist(String animeId) {
    return _db.existCollection(animeId);
  }

  /// 添加收藏
  Future<int> insertCollection(Collection collection) {
    return _db.insertCollection(collection);
  }

  /// 删除收藏
  Future<int> deleteCollection(String animeId) {
    return _db.deleteCollection(animeId);
  }
}

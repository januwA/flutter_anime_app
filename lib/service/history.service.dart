import 'package:flutter_video_app/sqflite_db/model/history.dart';
import 'package:flutter_video_app/sqflite_db/sqflite_db.dart';

/// 历史记录服务
class HistoryService {
  // final AppDatabase _db = AppDatabase();
  AnimeDB _db = AnimeDB();

  /// 创建一条历史记录
  Future<History> create(History history) {
    return _db.createHistory(history);
  }

  /// 更新一条历史记录
  update(History history) => _db.updateHistory(history);

  /// 删除历史记录
  delete(History history) => _db.deleteHistory(history);

  /// 检测该anime是否存在
  Future<bool> exist(String animeId) => _db.existHistory(animeId);

  /// 所有历史记录列表
  Future<List<History>> get historys => _db.findAllHistorys();

  /// 获取指定anime的历史记录
  Future<History> findOneByAnimeId(String animeId) =>
      _db.findOneByAnimeId(animeId);
}

import 'package:flutter_video_app/db/app_database.dart';
import 'package:mobx/mobx.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'history.service.g.dart';

/// 历史记录服务
class HistoryService = _HistoryService with _$HistoryService;

abstract class _HistoryService with Store {
  final AppDatabase _db = AppDatabase();
  HistoryDao get _historyDao => _db.historyDao;

  /// 创建一条历史记录
  Future<History> create(Insertable<History> history) async {
    return await _historyDao.createHistory(history);
  }

  /// 更新一条历史记录
  update(History history) {
    _historyDao.updateHistory(history);
  }

  /// 删除历史记录
  delete(History history) {
    _historyDao.deleteHistory(history);
  }

  /// 检测该anime是否存在
  Future<bool> exist(String animeId) async {
    return await _historyDao.existHistory(animeId);
  }

  /// 所有历史记录列表
  Stream<List<History>> get historys$ => _historyDao.findAll$();

  /// 获取指定anime的历史记录
  Future<History> findOneByAnimeId(String animeId) async {
    return await _historyDao.findOneByAnimeId(animeId);
  }
}


import 'package:moor_flutter/moor_flutter.dart';

import 'app_database.dart';

part 'historys.table.g.dart';

class Historys extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get animeId => text()(); // anime id
  TextColumn get cover => text()(); // anime 封面
  TextColumn get title => text()(); // anime 标题
  DateTimeColumn get time => dateTime()(); // 历史记录创建时间
  TextColumn get playCurrent => text().nullable()(); // 第几话
  TextColumn get playCurrentId => text().nullable()(); // 第几话 id
  TextColumn get playCurrentBoxUrl => text().nullable()(); // 第几话 boxUrl
  IntColumn get position =>
      integer().withDefault(const Constant(0))(); // 播放位置 用秒存储

  IntColumn get duration =>
      integer().withDefault(const Constant(0))(); // 总时长 用秒存储
}


@UseDao(tables: [Historys])
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  final AppDatabase db;
  HistoryDao(this.db) : super(db);

  Stream<List<History>> findAll$() => (select(historys)
        ..orderBy([
          // 将最近的观看的历史记录，放在前面
          (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc),
        ]))
      .watch();

  Future<History> findOneByAnimeId(String animeId) async {
    var data = await (select(historys)..where((t) => t.animeId.equals(animeId)))
        .getSingle();
    return data;
  }

  Future<History> findOneById(int id) async {
    var data =
        await (select(historys)..where((t) => t.id.equals(id))).getSingle();
    return data;
  }

  Future<History> createHistory(Insertable<History> history) async {
    int id = await into(historys).insert(history);
    if (id != null) {
      return findOneById(id);
    }
    return null;
  }

  Future<bool> updateHistory(Insertable<History> history) =>
      update(historys).replace(history);

  Future<int> deleteHistory(Insertable<History> history) =>
      delete(historys).delete(history);

  Future<bool> existHistory(String animeId) async {
    var data = await findOneByAnimeId(animeId);
    return data != null;
  }
}
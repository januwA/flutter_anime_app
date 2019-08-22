import 'package:moor_flutter/moor_flutter.dart';

part 'history.g.dart';

class Historys extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get animeId => text()(); // anime id
  TextColumn get cover => text()(); // anime 封面
  TextColumn get title => text()(); // anime 标题
  DateTimeColumn get time => dateTime()(); // 历史记录创建时间
  TextColumn get playCurrent => text()(); // 第几话
  IntColumn get position =>
      integer().withDefault(const Constant(0))(); // 播放位置 用秒存储

  IntColumn get duration =>
      integer().withDefault(const Constant(0))(); // 总时长 用秒存储
}

@UseMoor(tables: [Historys], daos: [HistoryDao])
class HistoryDatabase extends _$HistoryDatabase {
  HistoryDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));
  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [Historys])
class HistoryDao extends DatabaseAccessor<HistoryDatabase>
    with _$HistoryDaoMixin {
  final HistoryDatabase db;
  HistoryDao(this.db) : super(db);

  Stream<List<History>> findAll() => select(historys).watch();
  Future<History> findOne(String animeId) async {
    var data = await (select(historys)..where((t) => t.animeId.equals(animeId)))
        .getSingle();
    return data;
  }

  Future<int> insertHistory(Insertable<History> history) =>
      into(historys).insert(history);

  Future<bool> updateHistory(Insertable<History> history) =>
      update(historys).replace(history);

  Future<int> deleteHistory(Insertable<History> history) =>
      delete(historys).delete(history);

  Future<bool> existHistory(String animeId) async {
    var data = await findOne(animeId);
    return data == null;
  }
}

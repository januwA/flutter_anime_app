import 'package:moor_flutter/moor_flutter.dart';

part 'app_database.g.dart';

class Collections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get animeId => text()();
}

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

@UseMoor(tables: [Collections, Historys], daos: [CollectionDao, HistoryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));
  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [Collections])
class CollectionDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionDaoMixin {
  final AppDatabase db;
  CollectionDao(this.db) : super(db);

  Future<List<Collection>> getAllCollections() => select(collections).get();

  Future<bool> exist(String animeId) async {
    var data = await (select(collections)
          ..where((t) => t.animeId.equals(animeId)))
        .getSingle();
    return data == null;
  }

  Stream<List<Collection>> watchAllCollections() => select(collections).watch();

  Future<int> insertCollection(Insertable<Collection> collection) =>
      into(collections).insert(collection);

  Future<int> deleteCollection(String animeId) =>
      (delete(collections)..where((t) => t.animeId.equals(animeId))).go();
}

@UseDao(tables: [Historys])
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  final AppDatabase db;
  HistoryDao(this.db) : super(db);

  Stream<List<History>> findAll() => select(historys).watch();

  Future<History> findOne(String animeId) async {
    var data = await (select(historys)..where((t) => t.animeId.equals(animeId)))
        .getSingle();
    return data;
  }

  Future<int> insertHistory(Insertable<History> history) {
    return into(historys).insert(history);
  }

  Future<bool> updateHistory(Insertable<History> history) =>
      update(historys).replace(history);

  Future<int> deleteHistory(Insertable<History> history) =>
      delete(historys).delete(history);

  Future<bool> existHistory(String animeId) async {
    var data = await findOne(animeId);
    return data != null;
  }
}

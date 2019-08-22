import 'package:moor_flutter/moor_flutter.dart';

part 'collections.moor.g.dart';

class Collections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get animeId => text()();
}

@UseMoor(tables: [Collections], daos: [CollectionDao])
class CollectionDatabase extends _$CollectionDatabase {
  CollectionDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));
  @override
  int get schemaVersion => 1;
}

@UseDao(
  tables: [Collections],
)
class CollectionDao extends DatabaseAccessor<CollectionDatabase>
    with _$CollectionDaoMixin {
  final CollectionDatabase db;
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

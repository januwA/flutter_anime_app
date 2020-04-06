import 'package:moor/moor.dart';
import 'app_database.dart';

part 'collections.table.g.dart';

class Collections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get animeId => text()();
}

@UseDao(tables: [Collections])
class CollectionDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionDaoMixin {
  CollectionDao(AppDatabase db) : super(db);

  Future<List<Collection>> getAllCollections() => select(collections).get();

  Future<bool> exist(String animeId) async {
    var data = await (select(collections)
          ..where((t) => t.animeId.equals(animeId)))
        .getSingle();
    return data != null;
  }

  Stream<List<Collection>> watchAllCollections() => select(collections).watch();

  Future<int> insertCollection(Insertable<Collection> collection) =>
      into(collections).insert(collection);

  Future<int> deleteCollection(String animeId) =>
      (delete(collections)..where((t) => t.animeId.equals(animeId))).go();
}

import 'package:flutter_video_app/db/historys.table.dart';
import 'package:moor_flutter/moor_flutter.dart';

import 'collections.table.dart';

part 'app_database.g.dart';



@UseMoor(tables: [Collections, Historys], daos: [CollectionDao, HistoryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        await m.addColumn(historys, historys.playCurrentId);
        await m.addColumn(historys, historys.playCurrentBoxUrl);
      }
    });
  }
}
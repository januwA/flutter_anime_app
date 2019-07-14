import 'dart:convert';

import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'collections.service.g.dart';

class CollectionsService = _CollectionsService with _$CollectionsService;

/// 收藏
final String tablename = 'collections';

abstract class _CollectionsService with Store {
  _CollectionsService() {
    _init();
  }
  Future<Database> database;

  /// 所有收藏的数据
  @observable
  ObservableList<LiData> collections = ObservableList<LiData>();

  /// 服务被初始化时创建数据库
  @action
  Future<void> _init() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'collections_database.db'),
      onCreate: (db, version) {
        return db.execute(
          """
          CREATE TABLE $tablename (
              title   VARCHAR NOT NULL,
              img     VARCHAR NOT NULL,
              current VARCHAR NOT NULL,
              id VARCHAR NOT NULL
          );
          """,
        );
      },
      version: 1,
    );
    queryAll();
  }

  /// 查询所有
  @action
  queryAll() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tablename);
    collections = ObservableList.of(
      maps.map(
        (m) => LiData(
          (b) => b
            ..id = m['id']
            ..current = m['current']
            ..img = m['img']
            ..title = m['title'],
        ),
      ),
    );
  }

  /// 添加一个收藏
  @action
  Future<void> addOne(LiData c) async {
    final Database db = await database;
    Map value = jsonDecode(c.toJson());
    print(value);
    db.insert(
      tablename,
      value,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    collections.add(c);
  }

  /// 移除一个收藏
  @action
  Future<void> remove(LiData c) async {
    final db = await database;
    await db.delete(
      tablename,
      where: "id = ?",
      whereArgs: [c.id],
    );
    collections.removeWhere((x) => x == c);
  }

  @action
  bool exist(String animeId) {
    for (var c in collections) {
      if (c.id == animeId) return true;
    }
    return false;
  }
}

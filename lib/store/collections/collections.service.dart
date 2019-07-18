import 'dart:convert';

import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:html/dom.dart' as dom;

part 'collections.service.g.dart';

class CollectionsService = _CollectionsService with _$CollectionsService;

/// 收藏
final String tablename = 'collections';

abstract class _CollectionsService with Store {
  _CollectionsService() {
    _init();
  }

  @observable
  bool isLoading = true;

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
              id      INTEGER  PRIMARY KEY AUTOINCREMENT,
              animeId VARCHAR NOT NULL
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
    isLoading = true;
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tablename);
    for (var m in maps) {
      String animeId = m['animeId'];
      dom.Document document =
          await $document('http://www.nicotv.me/video/detail/$animeId.html');
      dom.Element mediaBody = $(document, '.media-body');
      collections.add(
        LiData.fromJson(
          jsonEncode(
            {
              "id": animeId,
              "title": $(mediaBody, 'h2 a').innerHtml.trim(),
              "img": $(document, '.media-left img').attributes['data-original'],
              "current": $(mediaBody, 'h2 small').innerHtml.trim(),
            },
          ),
        ),
      );
    }
    // print('collections length: ${collections.length}');
    isLoading = false;
  }

  /// 添加一个收藏
  @action
  Future<void> addOne(LiData c) async {
    final Database db = await database;
    db.insert(
      tablename,
      {
        'id': null,
        'animeId': c.id,
      },
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
      where: "animeId = ?",
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

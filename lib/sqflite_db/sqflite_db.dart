/// https://flutter.cn/docs/cookbook/persistence/sqlite

import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'model/collection.dart';
import 'model/history.dart';

class AnimeDB {
  static AnimeDB _o;

  static final String historyTable = 'historys';
  static final String collectionTable = 'collections';

  Future<Database> database;

  AnimeDB._() {
    _openDB();
  }

  factory AnimeDB() {
    if (_o == null) {
      _o = AnimeDB._();
    }
    return _o;
  }

  /// 打开数据库并存储引用。
  _openDB() async {
    print('init database.');
    database = openDatabase(
      // 设置数据库的路径。
      p.join(await getDatabasesPath(), 'anime_ajanuw.db'),
      // 首次创建数据库时，创表
      onCreate: (db, version) async {
        try {
          // 历史记录表
          await db.execute(
            '''
          CREATE TABLE ${historyTable} (
              id                INTEGER PRIMARY KEY AUTOINCREMENT,
              animeId           TEXT    NOT NULL,
              cover             TEXT    NOT NULL,
              title             TEXT    NOT NULL,
              playCurrent       TEXT,
              playCurrentId     TEXT,
              playCurrentBoxUrl TEXT,
              time              DATE,
              position          INTEGER DEFAULT (0),
              duration          INTEGER DEFAULT (0) 
          );
         ''',
          );
          // 搜藏表
          await db.execute('''
          CREATE TABLE ${collectionTable} (
              id      INTEGER PRIMARY KEY AUTOINCREMENT, 
              animeId TEXT NOT NULL
            );
        ''');
        } catch (e) {
          print('建表失败.');
        }
      },
      version: 1, // 设置版本。 这将执行onCreate函数并提供一个,执行数据库升级和降级的路径。
    );
  }

  /// 返回所有的收藏记录
  Future<List<Collection>> getAllCollections() async {
    final Database db = await database;
    final List<Map<String, dynamic>> datas = await db.query(collectionTable);
    return List.generate(datas.length, (i) {
      return Collection.from(datas[i]);
    });
  }

  /// 否存在某条搜藏记录，是否存在
  Future<bool> existCollection(String animeId) async {
    final Database db = await database;
    var datas = await db
        .query(collectionTable, where: "animeId = ?", whereArgs: [animeId]);
    return datas.isNotEmpty;
  }

  /// 添加搜藏
  Future<int> insertCollection(Collection collection) async {
    final Database db = await database;
    return await db.insert(
      collectionTable,
      collection.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace, // 如果存在则替换
    );
  }

  /// 删除搜藏
  Future<int> deleteCollection(String animeId) async {
    final Database db = await database;
    return await db.delete(
      collectionTable,
      where: "animeId = ?",
      whereArgs: [animeId],
    );
  }

  /// 返回所有历史记录
  Future<List<History>> findAllHistorys() async {
    final Database db = await database;
    final List<Map<String, dynamic>> datas =
        await db.query(historyTable, orderBy: "time desc");
    return datas.map((e) => History.from(e)).toList();
  }

  /// 返回指定的历史记录
  Future<History> findOneByAnimeId(String animeId) async {
    final Database db = await database;
    var datas = await db.query(
      historyTable,
      where: "animeId = ?",
      whereArgs: [animeId],
    );
    if (datas == null || datas.isEmpty) return null;
    return History.from(datas.first);
  }

  Future<History> findOneById(int id) async {
    final Database db = await database;
    var datas = await db.query(
      historyTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (datas == null || datas.isEmpty) return null;
    return History.from(datas.first);
  }

  Future<History> createHistory(History history) async {
    final Database db = await database;
    int id = await db.insert(historyTable, history.toMap());
    if (id != null) return findOneById(id);
    return null;
  }

  Future<int> updateHistory(History history) async {
    final Database db = await database;
    return db.update(
      historyTable,
      history.toMap(),
      where: 'id = ?',
      whereArgs: [history.id],
      conflictAlgorithm: ConflictAlgorithm.replace, // 如果存在则替换
    );
  }

  Future<int> deleteHistory(History history) async {
    final Database db = await database;
    return db.delete(historyTable, where: "id = ?", whereArgs: [history.id]);
  }
}

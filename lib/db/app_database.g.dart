// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class Collection extends DataClass implements Insertable<Collection> {
  final int id;
  final String animeId;
  Collection({@required this.id, @required this.animeId});
  factory Collection.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Collection(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      animeId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}anime_id']),
    );
  }
  factory Collection.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Collection(
      id: serializer.fromJson<int>(json['id']),
      animeId: serializer.fromJson<String>(json['animeId']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'animeId': serializer.toJson<String>(animeId),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<Collection>>(bool nullToAbsent) {
    return CollectionsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      animeId: animeId == null && nullToAbsent
          ? const Value.absent()
          : Value(animeId),
    ) as T;
  }

  Collection copyWith({int id, String animeId}) => Collection(
        id: id ?? this.id,
        animeId: animeId ?? this.animeId,
      );
  @override
  String toString() {
    return (StringBuffer('Collection(')
          ..write('id: $id, ')
          ..write('animeId: $animeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, animeId.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Collection && other.id == id && other.animeId == animeId);
}

class CollectionsCompanion extends UpdateCompanion<Collection> {
  final Value<int> id;
  final Value<String> animeId;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.animeId = const Value.absent(),
  });
  CollectionsCompanion copyWith({Value<int> id, Value<String> animeId}) {
    return CollectionsCompanion(
      id: id ?? this.id,
      animeId: animeId ?? this.animeId,
    );
  }
}

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, Collection> {
  final GeneratedDatabase _db;
  final String _alias;
  $CollectionsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _animeIdMeta = const VerificationMeta('animeId');
  GeneratedTextColumn _animeId;
  @override
  GeneratedTextColumn get animeId => _animeId ??= _constructAnimeId();
  GeneratedTextColumn _constructAnimeId() {
    return GeneratedTextColumn(
      'anime_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, animeId];
  @override
  $CollectionsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'collections';
  @override
  final String actualTableName = 'collections';
  @override
  VerificationContext validateIntegrity(CollectionsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.animeId.present) {
      context.handle(_animeIdMeta,
          animeId.isAcceptableValue(d.animeId.value, _animeIdMeta));
    } else if (animeId.isRequired && isInserting) {
      context.missing(_animeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Collection map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Collection.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(CollectionsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.animeId.present) {
      map['anime_id'] = Variable<String, StringType>(d.animeId.value);
    }
    return map;
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(_db, alias);
  }
}

class History extends DataClass implements Insertable<History> {
  final int id;
  final String animeId;
  final String cover;
  final String title;
  final DateTime time;
  final String playCurrent;
  final String playCurrentId;
  final String playCurrentBoxUrl;
  final int position;
  final int duration;
  History(
      {@required this.id,
      @required this.animeId,
      @required this.cover,
      @required this.title,
      @required this.time,
      this.playCurrent,
      this.playCurrentId,
      this.playCurrentBoxUrl,
      @required this.position,
      @required this.duration});
  factory History.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return History(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      animeId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}anime_id']),
      cover:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}cover']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      time:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}time']),
      playCurrent: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}play_current']),
      playCurrentId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}play_current_id']),
      playCurrentBoxUrl: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}play_current_box_url']),
      position:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}position']),
      duration:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}duration']),
    );
  }
  factory History.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return History(
      id: serializer.fromJson<int>(json['id']),
      animeId: serializer.fromJson<String>(json['animeId']),
      cover: serializer.fromJson<String>(json['cover']),
      title: serializer.fromJson<String>(json['title']),
      time: serializer.fromJson<DateTime>(json['time']),
      playCurrent: serializer.fromJson<String>(json['playCurrent']),
      playCurrentId: serializer.fromJson<String>(json['playCurrentId']),
      playCurrentBoxUrl: serializer.fromJson<String>(json['playCurrentBoxUrl']),
      position: serializer.fromJson<int>(json['position']),
      duration: serializer.fromJson<int>(json['duration']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'animeId': serializer.toJson<String>(animeId),
      'cover': serializer.toJson<String>(cover),
      'title': serializer.toJson<String>(title),
      'time': serializer.toJson<DateTime>(time),
      'playCurrent': serializer.toJson<String>(playCurrent),
      'playCurrentId': serializer.toJson<String>(playCurrentId),
      'playCurrentBoxUrl': serializer.toJson<String>(playCurrentBoxUrl),
      'position': serializer.toJson<int>(position),
      'duration': serializer.toJson<int>(duration),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<History>>(bool nullToAbsent) {
    return HistorysCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      animeId: animeId == null && nullToAbsent
          ? const Value.absent()
          : Value(animeId),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      playCurrent: playCurrent == null && nullToAbsent
          ? const Value.absent()
          : Value(playCurrent),
      playCurrentId: playCurrentId == null && nullToAbsent
          ? const Value.absent()
          : Value(playCurrentId),
      playCurrentBoxUrl: playCurrentBoxUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(playCurrentBoxUrl),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
    ) as T;
  }

  History copyWith(
          {int id,
          String animeId,
          String cover,
          String title,
          DateTime time,
          String playCurrent,
          String playCurrentId,
          String playCurrentBoxUrl,
          int position,
          int duration}) =>
      History(
        id: id ?? this.id,
        animeId: animeId ?? this.animeId,
        cover: cover ?? this.cover,
        title: title ?? this.title,
        time: time ?? this.time,
        playCurrent: playCurrent ?? this.playCurrent,
        playCurrentId: playCurrentId ?? this.playCurrentId,
        playCurrentBoxUrl: playCurrentBoxUrl ?? this.playCurrentBoxUrl,
        position: position ?? this.position,
        duration: duration ?? this.duration,
      );
  @override
  String toString() {
    return (StringBuffer('History(')
          ..write('id: $id, ')
          ..write('animeId: $animeId, ')
          ..write('cover: $cover, ')
          ..write('title: $title, ')
          ..write('time: $time, ')
          ..write('playCurrent: $playCurrent, ')
          ..write('playCurrentId: $playCurrentId, ')
          ..write('playCurrentBoxUrl: $playCurrentBoxUrl, ')
          ..write('position: $position, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          animeId.hashCode,
          $mrjc(
              cover.hashCode,
              $mrjc(
                  title.hashCode,
                  $mrjc(
                      time.hashCode,
                      $mrjc(
                          playCurrent.hashCode,
                          $mrjc(
                              playCurrentId.hashCode,
                              $mrjc(
                                  playCurrentBoxUrl.hashCode,
                                  $mrjc(position.hashCode,
                                      duration.hashCode))))))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is History &&
          other.id == id &&
          other.animeId == animeId &&
          other.cover == cover &&
          other.title == title &&
          other.time == time &&
          other.playCurrent == playCurrent &&
          other.playCurrentId == playCurrentId &&
          other.playCurrentBoxUrl == playCurrentBoxUrl &&
          other.position == position &&
          other.duration == duration);
}

class HistorysCompanion extends UpdateCompanion<History> {
  final Value<int> id;
  final Value<String> animeId;
  final Value<String> cover;
  final Value<String> title;
  final Value<DateTime> time;
  final Value<String> playCurrent;
  final Value<String> playCurrentId;
  final Value<String> playCurrentBoxUrl;
  final Value<int> position;
  final Value<int> duration;
  const HistorysCompanion({
    this.id = const Value.absent(),
    this.animeId = const Value.absent(),
    this.cover = const Value.absent(),
    this.title = const Value.absent(),
    this.time = const Value.absent(),
    this.playCurrent = const Value.absent(),
    this.playCurrentId = const Value.absent(),
    this.playCurrentBoxUrl = const Value.absent(),
    this.position = const Value.absent(),
    this.duration = const Value.absent(),
  });
  HistorysCompanion copyWith(
      {Value<int> id,
      Value<String> animeId,
      Value<String> cover,
      Value<String> title,
      Value<DateTime> time,
      Value<String> playCurrent,
      Value<String> playCurrentId,
      Value<String> playCurrentBoxUrl,
      Value<int> position,
      Value<int> duration}) {
    return HistorysCompanion(
      id: id ?? this.id,
      animeId: animeId ?? this.animeId,
      cover: cover ?? this.cover,
      title: title ?? this.title,
      time: time ?? this.time,
      playCurrent: playCurrent ?? this.playCurrent,
      playCurrentId: playCurrentId ?? this.playCurrentId,
      playCurrentBoxUrl: playCurrentBoxUrl ?? this.playCurrentBoxUrl,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

class $HistorysTable extends Historys with TableInfo<$HistorysTable, History> {
  final GeneratedDatabase _db;
  final String _alias;
  $HistorysTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _animeIdMeta = const VerificationMeta('animeId');
  GeneratedTextColumn _animeId;
  @override
  GeneratedTextColumn get animeId => _animeId ??= _constructAnimeId();
  GeneratedTextColumn _constructAnimeId() {
    return GeneratedTextColumn(
      'anime_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _coverMeta = const VerificationMeta('cover');
  GeneratedTextColumn _cover;
  @override
  GeneratedTextColumn get cover => _cover ??= _constructCover();
  GeneratedTextColumn _constructCover() {
    return GeneratedTextColumn(
      'cover',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _timeMeta = const VerificationMeta('time');
  GeneratedDateTimeColumn _time;
  @override
  GeneratedDateTimeColumn get time => _time ??= _constructTime();
  GeneratedDateTimeColumn _constructTime() {
    return GeneratedDateTimeColumn(
      'time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _playCurrentMeta =
      const VerificationMeta('playCurrent');
  GeneratedTextColumn _playCurrent;
  @override
  GeneratedTextColumn get playCurrent =>
      _playCurrent ??= _constructPlayCurrent();
  GeneratedTextColumn _constructPlayCurrent() {
    return GeneratedTextColumn(
      'play_current',
      $tableName,
      true,
    );
  }

  final VerificationMeta _playCurrentIdMeta =
      const VerificationMeta('playCurrentId');
  GeneratedTextColumn _playCurrentId;
  @override
  GeneratedTextColumn get playCurrentId =>
      _playCurrentId ??= _constructPlayCurrentId();
  GeneratedTextColumn _constructPlayCurrentId() {
    return GeneratedTextColumn(
      'play_current_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _playCurrentBoxUrlMeta =
      const VerificationMeta('playCurrentBoxUrl');
  GeneratedTextColumn _playCurrentBoxUrl;
  @override
  GeneratedTextColumn get playCurrentBoxUrl =>
      _playCurrentBoxUrl ??= _constructPlayCurrentBoxUrl();
  GeneratedTextColumn _constructPlayCurrentBoxUrl() {
    return GeneratedTextColumn(
      'play_current_box_url',
      $tableName,
      true,
    );
  }

  final VerificationMeta _positionMeta = const VerificationMeta('position');
  GeneratedIntColumn _position;
  @override
  GeneratedIntColumn get position => _position ??= _constructPosition();
  GeneratedIntColumn _constructPosition() {
    return GeneratedIntColumn('position', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _durationMeta = const VerificationMeta('duration');
  GeneratedIntColumn _duration;
  @override
  GeneratedIntColumn get duration => _duration ??= _constructDuration();
  GeneratedIntColumn _constructDuration() {
    return GeneratedIntColumn('duration', $tableName, false,
        defaultValue: const Constant(0));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        animeId,
        cover,
        title,
        time,
        playCurrent,
        playCurrentId,
        playCurrentBoxUrl,
        position,
        duration
      ];
  @override
  $HistorysTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'historys';
  @override
  final String actualTableName = 'historys';
  @override
  VerificationContext validateIntegrity(HistorysCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.animeId.present) {
      context.handle(_animeIdMeta,
          animeId.isAcceptableValue(d.animeId.value, _animeIdMeta));
    } else if (animeId.isRequired && isInserting) {
      context.missing(_animeIdMeta);
    }
    if (d.cover.present) {
      context.handle(
          _coverMeta, cover.isAcceptableValue(d.cover.value, _coverMeta));
    } else if (cover.isRequired && isInserting) {
      context.missing(_coverMeta);
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (title.isRequired && isInserting) {
      context.missing(_titleMeta);
    }
    if (d.time.present) {
      context.handle(
          _timeMeta, time.isAcceptableValue(d.time.value, _timeMeta));
    } else if (time.isRequired && isInserting) {
      context.missing(_timeMeta);
    }
    if (d.playCurrent.present) {
      context.handle(_playCurrentMeta,
          playCurrent.isAcceptableValue(d.playCurrent.value, _playCurrentMeta));
    } else if (playCurrent.isRequired && isInserting) {
      context.missing(_playCurrentMeta);
    }
    if (d.playCurrentId.present) {
      context.handle(
          _playCurrentIdMeta,
          playCurrentId.isAcceptableValue(
              d.playCurrentId.value, _playCurrentIdMeta));
    } else if (playCurrentId.isRequired && isInserting) {
      context.missing(_playCurrentIdMeta);
    }
    if (d.playCurrentBoxUrl.present) {
      context.handle(
          _playCurrentBoxUrlMeta,
          playCurrentBoxUrl.isAcceptableValue(
              d.playCurrentBoxUrl.value, _playCurrentBoxUrlMeta));
    } else if (playCurrentBoxUrl.isRequired && isInserting) {
      context.missing(_playCurrentBoxUrlMeta);
    }
    if (d.position.present) {
      context.handle(_positionMeta,
          position.isAcceptableValue(d.position.value, _positionMeta));
    } else if (position.isRequired && isInserting) {
      context.missing(_positionMeta);
    }
    if (d.duration.present) {
      context.handle(_durationMeta,
          duration.isAcceptableValue(d.duration.value, _durationMeta));
    } else if (duration.isRequired && isInserting) {
      context.missing(_durationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  History map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return History.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(HistorysCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.animeId.present) {
      map['anime_id'] = Variable<String, StringType>(d.animeId.value);
    }
    if (d.cover.present) {
      map['cover'] = Variable<String, StringType>(d.cover.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.time.present) {
      map['time'] = Variable<DateTime, DateTimeType>(d.time.value);
    }
    if (d.playCurrent.present) {
      map['play_current'] = Variable<String, StringType>(d.playCurrent.value);
    }
    if (d.playCurrentId.present) {
      map['play_current_id'] =
          Variable<String, StringType>(d.playCurrentId.value);
    }
    if (d.playCurrentBoxUrl.present) {
      map['play_current_box_url'] =
          Variable<String, StringType>(d.playCurrentBoxUrl.value);
    }
    if (d.position.present) {
      map['position'] = Variable<int, IntType>(d.position.value);
    }
    if (d.duration.present) {
      map['duration'] = Variable<int, IntType>(d.duration.value);
    }
    return map;
  }

  @override
  $HistorysTable createAlias(String alias) {
    return $HistorysTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.withDefaults(), e);
  $CollectionsTable _collections;
  $CollectionsTable get collections => _collections ??= $CollectionsTable(this);
  $HistorysTable _historys;
  $HistorysTable get historys => _historys ??= $HistorysTable(this);
  CollectionDao _collectionDao;
  CollectionDao get collectionDao =>
      _collectionDao ??= CollectionDao(this as AppDatabase);
  HistoryDao _historyDao;
  HistoryDao get historyDao => _historyDao ??= HistoryDao(this as AppDatabase);
  @override
  List<TableInfo> get allTables => [collections, historys];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$CollectionDaoMixin on DatabaseAccessor<AppDatabase> {
  $CollectionsTable get collections => db.collections;
}

mixin _$HistoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $HistorysTable get historys => db.historys;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of week_data_dto;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<WeekDataDto> _$weekDataDtoSerializer = new _$WeekDataDtoSerializer();
Serializer<WeekData> _$weekDataSerializer = new _$WeekDataSerializer();
Serializer<LiData> _$liDataSerializer = new _$LiDataSerializer();

class _$WeekDataDtoSerializer implements StructuredSerializer<WeekDataDto> {
  @override
  final Iterable<Type> types = const [WeekDataDto, _$WeekDataDto];
  @override
  final String wireName = 'WeekDataDto';

  @override
  Iterable serialize(Serializers serializers, WeekDataDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'weekData',
      serializers.serialize(object.weekData,
          specifiedType:
              const FullType(BuiltList, const [const FullType(WeekData)])),
    ];

    return result;
  }

  @override
  WeekDataDto deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WeekDataDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'weekData':
          result.weekData.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(WeekData)])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$WeekDataSerializer implements StructuredSerializer<WeekData> {
  @override
  final Iterable<Type> types = const [WeekData, _$WeekData];
  @override
  final String wireName = 'WeekData';

  @override
  Iterable serialize(Serializers serializers, WeekData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'index',
      serializers.serialize(object.index, specifiedType: const FullType(int)),
      'liData',
      serializers.serialize(object.liData,
          specifiedType:
              const FullType(BuiltList, const [const FullType(LiData)])),
    ];

    return result;
  }

  @override
  WeekData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WeekDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'index':
          result.index = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'liData':
          result.liData.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(LiData)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$LiDataSerializer implements StructuredSerializer<LiData> {
  @override
  final Iterable<Type> types = const [LiData, _$LiData];
  @override
  final String wireName = 'LiData';

  @override
  Iterable serialize(Serializers serializers, LiData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'img',
      serializers.serialize(object.img, specifiedType: const FullType(String)),
      'current',
      serializers.serialize(object.current,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  LiData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LiDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'img':
          result.img = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'current':
          result.current = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$WeekDataDto extends WeekDataDto {
  @override
  final BuiltList<WeekData> weekData;

  factory _$WeekDataDto([void Function(WeekDataDtoBuilder) updates]) =>
      (new WeekDataDtoBuilder()..update(updates)).build();

  _$WeekDataDto._({this.weekData}) : super._() {
    if (weekData == null) {
      throw new BuiltValueNullFieldError('WeekDataDto', 'weekData');
    }
  }

  @override
  WeekDataDto rebuild(void Function(WeekDataDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WeekDataDtoBuilder toBuilder() => new WeekDataDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WeekDataDto && weekData == other.weekData;
  }

  @override
  int get hashCode {
    return $jf($jc(0, weekData.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('WeekDataDto')
          ..add('weekData', weekData))
        .toString();
  }
}

class WeekDataDtoBuilder implements Builder<WeekDataDto, WeekDataDtoBuilder> {
  _$WeekDataDto _$v;

  ListBuilder<WeekData> _weekData;
  ListBuilder<WeekData> get weekData =>
      _$this._weekData ??= new ListBuilder<WeekData>();
  set weekData(ListBuilder<WeekData> weekData) => _$this._weekData = weekData;

  WeekDataDtoBuilder();

  WeekDataDtoBuilder get _$this {
    if (_$v != null) {
      _weekData = _$v.weekData?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WeekDataDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$WeekDataDto;
  }

  @override
  void update(void Function(WeekDataDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$WeekDataDto build() {
    _$WeekDataDto _$result;
    try {
      _$result = _$v ?? new _$WeekDataDto._(weekData: weekData.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'weekData';
        weekData.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'WeekDataDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$WeekData extends WeekData {
  @override
  final int index;
  @override
  final BuiltList<LiData> liData;

  factory _$WeekData([void Function(WeekDataBuilder) updates]) =>
      (new WeekDataBuilder()..update(updates)).build();

  _$WeekData._({this.index, this.liData}) : super._() {
    if (index == null) {
      throw new BuiltValueNullFieldError('WeekData', 'index');
    }
    if (liData == null) {
      throw new BuiltValueNullFieldError('WeekData', 'liData');
    }
  }

  @override
  WeekData rebuild(void Function(WeekDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WeekDataBuilder toBuilder() => new WeekDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WeekData && index == other.index && liData == other.liData;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, index.hashCode), liData.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('WeekData')
          ..add('index', index)
          ..add('liData', liData))
        .toString();
  }
}

class WeekDataBuilder implements Builder<WeekData, WeekDataBuilder> {
  _$WeekData _$v;

  int _index;
  int get index => _$this._index;
  set index(int index) => _$this._index = index;

  ListBuilder<LiData> _liData;
  ListBuilder<LiData> get liData =>
      _$this._liData ??= new ListBuilder<LiData>();
  set liData(ListBuilder<LiData> liData) => _$this._liData = liData;

  WeekDataBuilder();

  WeekDataBuilder get _$this {
    if (_$v != null) {
      _index = _$v.index;
      _liData = _$v.liData?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WeekData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$WeekData;
  }

  @override
  void update(void Function(WeekDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$WeekData build() {
    _$WeekData _$result;
    try {
      _$result = _$v ?? new _$WeekData._(index: index, liData: liData.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'liData';
        liData.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'WeekData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$LiData extends LiData {
  @override
  final String id;
  @override
  final String title;
  @override
  final String img;
  @override
  final String current;

  factory _$LiData([void Function(LiDataBuilder) updates]) =>
      (new LiDataBuilder()..update(updates)).build();

  _$LiData._({this.id, this.title, this.img, this.current}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('LiData', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('LiData', 'title');
    }
    if (img == null) {
      throw new BuiltValueNullFieldError('LiData', 'img');
    }
    if (current == null) {
      throw new BuiltValueNullFieldError('LiData', 'current');
    }
  }

  @override
  LiData rebuild(void Function(LiDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LiDataBuilder toBuilder() => new LiDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LiData &&
        id == other.id &&
        title == other.title &&
        img == other.img &&
        current == other.current;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, id.hashCode), title.hashCode), img.hashCode),
        current.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LiData')
          ..add('id', id)
          ..add('title', title)
          ..add('img', img)
          ..add('current', current))
        .toString();
  }
}

class LiDataBuilder implements Builder<LiData, LiDataBuilder> {
  _$LiData _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _img;
  String get img => _$this._img;
  set img(String img) => _$this._img = img;

  String _current;
  String get current => _$this._current;
  set current(String current) => _$this._current = current;

  LiDataBuilder();

  LiDataBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _img = _$v.img;
      _current = _$v.current;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LiData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LiData;
  }

  @override
  void update(void Function(LiDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LiData build() {
    final _$result =
        _$v ?? new _$LiData._(id: id, title: title, img: img, current: current);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

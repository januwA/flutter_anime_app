// GENERATED CODE - DO NOT MODIFY BY HAND

part of detail_data_dto;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DetailDataDto> _$detailDataDtoSerializer =
    new _$DetailDataDtoSerializer();
Serializer<DetailData> _$detailDataSerializer = new _$DetailDataSerializer();
Serializer<PlayUrlTab> _$playUrlTabSerializer = new _$PlayUrlTabSerializer();

class _$DetailDataDtoSerializer implements StructuredSerializer<DetailDataDto> {
  @override
  final Iterable<Type> types = const [DetailDataDto, _$DetailDataDto];
  @override
  final String wireName = 'DetailDataDto';

  @override
  Iterable serialize(Serializers serializers, DetailDataDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'detailData',
      serializers.serialize(object.detailData,
          specifiedType: const FullType(DetailData)),
    ];

    return result;
  }

  @override
  DetailDataDto deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DetailDataDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'detailData':
          result.detailData.replace(serializers.deserialize(value,
              specifiedType: const FullType(DetailData)) as DetailData);
          break;
      }
    }

    return result.build();
  }
}

class _$DetailDataSerializer implements StructuredSerializer<DetailData> {
  @override
  final Iterable<Type> types = const [DetailData, _$DetailData];
  @override
  final String wireName = 'DetailData';

  @override
  Iterable serialize(Serializers serializers, DetailData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'cover',
      serializers.serialize(object.cover,
          specifiedType: const FullType(String)),
      'videoName',
      serializers.serialize(object.videoName,
          specifiedType: const FullType(String)),
      'curentText',
      serializers.serialize(object.curentText,
          specifiedType: const FullType(String)),
      'starring',
      serializers.serialize(object.starring,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'director',
      serializers.serialize(object.director,
          specifiedType: const FullType(String)),
      'types',
      serializers.serialize(object.types,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'area',
      serializers.serialize(object.area, specifiedType: const FullType(String)),
      'years',
      serializers.serialize(object.years,
          specifiedType: const FullType(String)),
      'plot',
      serializers.serialize(object.plot, specifiedType: const FullType(String)),
      'playUrlTab',
      serializers.serialize(object.playUrlTab,
          specifiedType:
              const FullType(BuiltList, const [const FullType(PlayUrlTab)])),
    ];

    return result;
  }

  @override
  DetailData deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DetailDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'cover':
          result.cover = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'videoName':
          result.videoName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'curentText':
          result.curentText = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'starring':
          result.starring.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
        case 'director':
          result.director = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'types':
          result.types.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList);
          break;
        case 'area':
          result.area = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'years':
          result.years = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'plot':
          result.plot = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'playUrlTab':
          result.playUrlTab.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(PlayUrlTab)])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$PlayUrlTabSerializer implements StructuredSerializer<PlayUrlTab> {
  @override
  final Iterable<Type> types = const [PlayUrlTab, _$PlayUrlTab];
  @override
  final String wireName = 'PlayUrlTab';

  @override
  Iterable serialize(Serializers serializers, PlayUrlTab object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'isBox',
      serializers.serialize(object.isBox, specifiedType: const FullType(bool)),
      'src',
      serializers.serialize(object.src, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  PlayUrlTab deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PlayUrlTabBuilder();

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
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isBox':
          result.isBox = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'src':
          result.src = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DetailDataDto extends DetailDataDto {
  @override
  final DetailData detailData;

  factory _$DetailDataDto([void Function(DetailDataDtoBuilder) updates]) =>
      (new DetailDataDtoBuilder()..update(updates)).build();

  _$DetailDataDto._({this.detailData}) : super._() {
    if (detailData == null) {
      throw new BuiltValueNullFieldError('DetailDataDto', 'detailData');
    }
  }

  @override
  DetailDataDto rebuild(void Function(DetailDataDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DetailDataDtoBuilder toBuilder() => new DetailDataDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DetailDataDto && detailData == other.detailData;
  }

  @override
  int get hashCode {
    return $jf($jc(0, detailData.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DetailDataDto')
          ..add('detailData', detailData))
        .toString();
  }
}

class DetailDataDtoBuilder
    implements Builder<DetailDataDto, DetailDataDtoBuilder> {
  _$DetailDataDto _$v;

  DetailDataBuilder _detailData;
  DetailDataBuilder get detailData =>
      _$this._detailData ??= new DetailDataBuilder();
  set detailData(DetailDataBuilder detailData) =>
      _$this._detailData = detailData;

  DetailDataDtoBuilder();

  DetailDataDtoBuilder get _$this {
    if (_$v != null) {
      _detailData = _$v.detailData?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DetailDataDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DetailDataDto;
  }

  @override
  void update(void Function(DetailDataDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DetailDataDto build() {
    _$DetailDataDto _$result;
    try {
      _$result = _$v ?? new _$DetailDataDto._(detailData: detailData.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'detailData';
        detailData.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'DetailDataDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$DetailData extends DetailData {
  @override
  final String cover;
  @override
  final String videoName;
  @override
  final String curentText;
  @override
  final BuiltList<String> starring;
  @override
  final String director;
  @override
  final BuiltList<String> types;
  @override
  final String area;
  @override
  final String years;
  @override
  final String plot;
  @override
  final BuiltList<PlayUrlTab> playUrlTab;

  factory _$DetailData([void Function(DetailDataBuilder) updates]) =>
      (new DetailDataBuilder()..update(updates)).build();

  _$DetailData._(
      {this.cover,
      this.videoName,
      this.curentText,
      this.starring,
      this.director,
      this.types,
      this.area,
      this.years,
      this.plot,
      this.playUrlTab})
      : super._() {
    if (cover == null) {
      throw new BuiltValueNullFieldError('DetailData', 'cover');
    }
    if (videoName == null) {
      throw new BuiltValueNullFieldError('DetailData', 'videoName');
    }
    if (curentText == null) {
      throw new BuiltValueNullFieldError('DetailData', 'curentText');
    }
    if (starring == null) {
      throw new BuiltValueNullFieldError('DetailData', 'starring');
    }
    if (director == null) {
      throw new BuiltValueNullFieldError('DetailData', 'director');
    }
    if (types == null) {
      throw new BuiltValueNullFieldError('DetailData', 'types');
    }
    if (area == null) {
      throw new BuiltValueNullFieldError('DetailData', 'area');
    }
    if (years == null) {
      throw new BuiltValueNullFieldError('DetailData', 'years');
    }
    if (plot == null) {
      throw new BuiltValueNullFieldError('DetailData', 'plot');
    }
    if (playUrlTab == null) {
      throw new BuiltValueNullFieldError('DetailData', 'playUrlTab');
    }
  }

  @override
  DetailData rebuild(void Function(DetailDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DetailDataBuilder toBuilder() => new DetailDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DetailData &&
        cover == other.cover &&
        videoName == other.videoName &&
        curentText == other.curentText &&
        starring == other.starring &&
        director == other.director &&
        types == other.types &&
        area == other.area &&
        years == other.years &&
        plot == other.plot &&
        playUrlTab == other.playUrlTab;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc($jc(0, cover.hashCode),
                                        videoName.hashCode),
                                    curentText.hashCode),
                                starring.hashCode),
                            director.hashCode),
                        types.hashCode),
                    area.hashCode),
                years.hashCode),
            plot.hashCode),
        playUrlTab.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DetailData')
          ..add('cover', cover)
          ..add('videoName', videoName)
          ..add('curentText', curentText)
          ..add('starring', starring)
          ..add('director', director)
          ..add('types', types)
          ..add('area', area)
          ..add('years', years)
          ..add('plot', plot)
          ..add('playUrlTab', playUrlTab))
        .toString();
  }
}

class DetailDataBuilder implements Builder<DetailData, DetailDataBuilder> {
  _$DetailData _$v;

  String _cover;
  String get cover => _$this._cover;
  set cover(String cover) => _$this._cover = cover;

  String _videoName;
  String get videoName => _$this._videoName;
  set videoName(String videoName) => _$this._videoName = videoName;

  String _curentText;
  String get curentText => _$this._curentText;
  set curentText(String curentText) => _$this._curentText = curentText;

  ListBuilder<String> _starring;
  ListBuilder<String> get starring =>
      _$this._starring ??= new ListBuilder<String>();
  set starring(ListBuilder<String> starring) => _$this._starring = starring;

  String _director;
  String get director => _$this._director;
  set director(String director) => _$this._director = director;

  ListBuilder<String> _types;
  ListBuilder<String> get types => _$this._types ??= new ListBuilder<String>();
  set types(ListBuilder<String> types) => _$this._types = types;

  String _area;
  String get area => _$this._area;
  set area(String area) => _$this._area = area;

  String _years;
  String get years => _$this._years;
  set years(String years) => _$this._years = years;

  String _plot;
  String get plot => _$this._plot;
  set plot(String plot) => _$this._plot = plot;

  ListBuilder<PlayUrlTab> _playUrlTab;
  ListBuilder<PlayUrlTab> get playUrlTab =>
      _$this._playUrlTab ??= new ListBuilder<PlayUrlTab>();
  set playUrlTab(ListBuilder<PlayUrlTab> playUrlTab) =>
      _$this._playUrlTab = playUrlTab;

  DetailDataBuilder();

  DetailDataBuilder get _$this {
    if (_$v != null) {
      _cover = _$v.cover;
      _videoName = _$v.videoName;
      _curentText = _$v.curentText;
      _starring = _$v.starring?.toBuilder();
      _director = _$v.director;
      _types = _$v.types?.toBuilder();
      _area = _$v.area;
      _years = _$v.years;
      _plot = _$v.plot;
      _playUrlTab = _$v.playUrlTab?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DetailData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DetailData;
  }

  @override
  void update(void Function(DetailDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DetailData build() {
    _$DetailData _$result;
    try {
      _$result = _$v ??
          new _$DetailData._(
              cover: cover,
              videoName: videoName,
              curentText: curentText,
              starring: starring.build(),
              director: director,
              types: types.build(),
              area: area,
              years: years,
              plot: plot,
              playUrlTab: playUrlTab.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'starring';
        starring.build();

        _$failedField = 'types';
        types.build();

        _$failedField = 'playUrlTab';
        playUrlTab.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'DetailData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PlayUrlTab extends PlayUrlTab {
  @override
  final String id;
  @override
  final String text;
  @override
  final bool isBox;
  @override
  final String src;

  factory _$PlayUrlTab([void Function(PlayUrlTabBuilder) updates]) =>
      (new PlayUrlTabBuilder()..update(updates)).build();

  _$PlayUrlTab._({this.id, this.text, this.isBox, this.src}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('PlayUrlTab', 'id');
    }
    if (text == null) {
      throw new BuiltValueNullFieldError('PlayUrlTab', 'text');
    }
    if (isBox == null) {
      throw new BuiltValueNullFieldError('PlayUrlTab', 'isBox');
    }
    if (src == null) {
      throw new BuiltValueNullFieldError('PlayUrlTab', 'src');
    }
  }

  @override
  PlayUrlTab rebuild(void Function(PlayUrlTabBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlayUrlTabBuilder toBuilder() => new PlayUrlTabBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlayUrlTab &&
        id == other.id &&
        text == other.text &&
        isBox == other.isBox &&
        src == other.src;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, id.hashCode), text.hashCode), isBox.hashCode),
        src.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PlayUrlTab')
          ..add('id', id)
          ..add('text', text)
          ..add('isBox', isBox)
          ..add('src', src))
        .toString();
  }
}

class PlayUrlTabBuilder implements Builder<PlayUrlTab, PlayUrlTabBuilder> {
  _$PlayUrlTab _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _text;
  String get text => _$this._text;
  set text(String text) => _$this._text = text;

  bool _isBox;
  bool get isBox => _$this._isBox;
  set isBox(bool isBox) => _$this._isBox = isBox;

  String _src;
  String get src => _$this._src;
  set src(String src) => _$this._src = src;

  PlayUrlTabBuilder();

  PlayUrlTabBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _text = _$v.text;
      _isBox = _$v.isBox;
      _src = _$v.src;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlayUrlTab other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PlayUrlTab;
  }

  @override
  void update(void Function(PlayUrlTabBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PlayUrlTab build() {
    final _$result =
        _$v ?? new _$PlayUrlTab._(id: id, text: text, isBox: isBox, src: src);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

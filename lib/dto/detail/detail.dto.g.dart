// GENERATED CODE - DO NOT MODIFY BY HAND

part of deyail.dto;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DetailDto> _$detailDtoSerializer = new _$DetailDtoSerializer();
Serializer<TabsDto> _$tabsDtoSerializer = new _$TabsDtoSerializer();
Serializer<TabsValueDto> _$tabsValueDtoSerializer =
    new _$TabsValueDtoSerializer();

class _$DetailDtoSerializer implements StructuredSerializer<DetailDto> {
  @override
  final Iterable<Type> types = const [DetailDto, _$DetailDto];
  @override
  final String wireName = 'DetailDto';

  @override
  Iterable<Object> serialize(Serializers serializers, DetailDto object,
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
      'tabs',
      serializers.serialize(object.tabs,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'tabsValues',
      serializers.serialize(object.tabsValues,
          specifiedType:
              const FullType(BuiltList, const [const FullType(TabsDto)])),
    ];

    return result;
  }

  @override
  DetailDto deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DetailDtoBuilder();

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
              as BuiltList<dynamic>);
          break;
        case 'director':
          result.director = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'types':
          result.types.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<dynamic>);
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
        case 'tabs':
          result.tabs.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<dynamic>);
          break;
        case 'tabsValues':
          result.tabsValues.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TabsDto)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$TabsDtoSerializer implements StructuredSerializer<TabsDto> {
  @override
  final Iterable<Type> types = const [TabsDto, _$TabsDto];
  @override
  final String wireName = 'TabsDto';

  @override
  Iterable<Object> serialize(Serializers serializers, TabsDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'tabs',
      serializers.serialize(object.tabs,
          specifiedType:
              const FullType(BuiltList, const [const FullType(TabsValueDto)])),
    ];

    return result;
  }

  @override
  TabsDto deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TabsDtoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'tabs':
          result.tabs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(TabsValueDto)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$TabsValueDtoSerializer implements StructuredSerializer<TabsValueDto> {
  @override
  final Iterable<Type> types = const [TabsValueDto, _$TabsValueDto];
  @override
  final String wireName = 'TabsValueDto';

  @override
  Iterable<Object> serialize(Serializers serializers, TabsValueDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'boxUrl',
      serializers.serialize(object.boxUrl,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  TabsValueDto deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TabsValueDtoBuilder();

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
        case 'boxUrl':
          result.boxUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DetailDto extends DetailDto {
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
  final BuiltList<String> tabs;
  @override
  final BuiltList<TabsDto> tabsValues;

  factory _$DetailDto([void Function(DetailDtoBuilder) updates]) =>
      (new DetailDtoBuilder()..update(updates)).build();

  _$DetailDto._(
      {this.cover,
      this.videoName,
      this.curentText,
      this.starring,
      this.director,
      this.types,
      this.area,
      this.years,
      this.plot,
      this.tabs,
      this.tabsValues})
      : super._() {
    if (cover == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'cover');
    }
    if (videoName == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'videoName');
    }
    if (curentText == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'curentText');
    }
    if (starring == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'starring');
    }
    if (director == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'director');
    }
    if (types == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'types');
    }
    if (area == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'area');
    }
    if (years == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'years');
    }
    if (plot == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'plot');
    }
    if (tabs == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'tabs');
    }
    if (tabsValues == null) {
      throw new BuiltValueNullFieldError('DetailDto', 'tabsValues');
    }
  }

  @override
  DetailDto rebuild(void Function(DetailDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DetailDtoBuilder toBuilder() => new DetailDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DetailDto &&
        cover == other.cover &&
        videoName == other.videoName &&
        curentText == other.curentText &&
        starring == other.starring &&
        director == other.director &&
        types == other.types &&
        area == other.area &&
        years == other.years &&
        plot == other.plot &&
        tabs == other.tabs &&
        tabsValues == other.tabsValues;
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
            tabs.hashCode),
        tabsValues.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DetailDto')
          ..add('cover', cover)
          ..add('videoName', videoName)
          ..add('curentText', curentText)
          ..add('starring', starring)
          ..add('director', director)
          ..add('types', types)
          ..add('area', area)
          ..add('years', years)
          ..add('plot', plot)
          ..add('tabs', tabs)
          ..add('tabsValues', tabsValues))
        .toString();
  }
}

class DetailDtoBuilder implements Builder<DetailDto, DetailDtoBuilder> {
  _$DetailDto _$v;

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

  ListBuilder<String> _tabs;
  ListBuilder<String> get tabs => _$this._tabs ??= new ListBuilder<String>();
  set tabs(ListBuilder<String> tabs) => _$this._tabs = tabs;

  ListBuilder<TabsDto> _tabsValues;
  ListBuilder<TabsDto> get tabsValues =>
      _$this._tabsValues ??= new ListBuilder<TabsDto>();
  set tabsValues(ListBuilder<TabsDto> tabsValues) =>
      _$this._tabsValues = tabsValues;

  DetailDtoBuilder();

  DetailDtoBuilder get _$this {
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
      _tabs = _$v.tabs?.toBuilder();
      _tabsValues = _$v.tabsValues?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DetailDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DetailDto;
  }

  @override
  void update(void Function(DetailDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DetailDto build() {
    _$DetailDto _$result;
    try {
      _$result = _$v ??
          new _$DetailDto._(
              cover: cover,
              videoName: videoName,
              curentText: curentText,
              starring: starring.build(),
              director: director,
              types: types.build(),
              area: area,
              years: years,
              plot: plot,
              tabs: tabs.build(),
              tabsValues: tabsValues.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'starring';
        starring.build();

        _$failedField = 'types';
        types.build();

        _$failedField = 'tabs';
        tabs.build();
        _$failedField = 'tabsValues';
        tabsValues.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'DetailDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$TabsDto extends TabsDto {
  @override
  final BuiltList<TabsValueDto> tabs;

  factory _$TabsDto([void Function(TabsDtoBuilder) updates]) =>
      (new TabsDtoBuilder()..update(updates)).build();

  _$TabsDto._({this.tabs}) : super._() {
    if (tabs == null) {
      throw new BuiltValueNullFieldError('TabsDto', 'tabs');
    }
  }

  @override
  TabsDto rebuild(void Function(TabsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TabsDtoBuilder toBuilder() => new TabsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TabsDto && tabs == other.tabs;
  }

  @override
  int get hashCode {
    return $jf($jc(0, tabs.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TabsDto')..add('tabs', tabs))
        .toString();
  }
}

class TabsDtoBuilder implements Builder<TabsDto, TabsDtoBuilder> {
  _$TabsDto _$v;

  ListBuilder<TabsValueDto> _tabs;
  ListBuilder<TabsValueDto> get tabs =>
      _$this._tabs ??= new ListBuilder<TabsValueDto>();
  set tabs(ListBuilder<TabsValueDto> tabs) => _$this._tabs = tabs;

  TabsDtoBuilder();

  TabsDtoBuilder get _$this {
    if (_$v != null) {
      _tabs = _$v.tabs?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TabsDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TabsDto;
  }

  @override
  void update(void Function(TabsDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TabsDto build() {
    _$TabsDto _$result;
    try {
      _$result = _$v ?? new _$TabsDto._(tabs: tabs.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'tabs';
        tabs.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TabsDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$TabsValueDto extends TabsValueDto {
  @override
  final String id;
  @override
  final String text;
  @override
  final String boxUrl;

  factory _$TabsValueDto([void Function(TabsValueDtoBuilder) updates]) =>
      (new TabsValueDtoBuilder()..update(updates)).build();

  _$TabsValueDto._({this.id, this.text, this.boxUrl}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('TabsValueDto', 'id');
    }
    if (text == null) {
      throw new BuiltValueNullFieldError('TabsValueDto', 'text');
    }
    if (boxUrl == null) {
      throw new BuiltValueNullFieldError('TabsValueDto', 'boxUrl');
    }
  }

  @override
  TabsValueDto rebuild(void Function(TabsValueDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TabsValueDtoBuilder toBuilder() => new TabsValueDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TabsValueDto &&
        id == other.id &&
        text == other.text &&
        boxUrl == other.boxUrl;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, id.hashCode), text.hashCode), boxUrl.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TabsValueDto')
          ..add('id', id)
          ..add('text', text)
          ..add('boxUrl', boxUrl))
        .toString();
  }
}

class TabsValueDtoBuilder
    implements Builder<TabsValueDto, TabsValueDtoBuilder> {
  _$TabsValueDto _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _text;
  String get text => _$this._text;
  set text(String text) => _$this._text = text;

  String _boxUrl;
  String get boxUrl => _$this._boxUrl;
  set boxUrl(String boxUrl) => _$this._boxUrl = boxUrl;

  TabsValueDtoBuilder();

  TabsValueDtoBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _text = _$v.text;
      _boxUrl = _$v.boxUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TabsValueDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TabsValueDto;
  }

  @override
  void update(void Function(TabsValueDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TabsValueDto build() {
    final _$result =
        _$v ?? new _$TabsValueDto._(id: id, text: text, boxUrl: boxUrl);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

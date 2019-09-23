// GENERATED CODE - DO NOT MODIFY BY HAND

part of list_search_dto;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ListSearchDto> _$listSearchDtoSerializer =
    new _$ListSearchDtoSerializer();

class _$ListSearchDtoSerializer implements StructuredSerializer<ListSearchDto> {
  @override
  final Iterable<Type> types = const [ListSearchDto, _$ListSearchDto];
  @override
  final String wireName = 'ListSearchDto';

  @override
  Iterable<Object> serialize(Serializers serializers, ListSearchDto object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'href',
      serializers.serialize(object.href, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ListSearchDto deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ListSearchDtoBuilder();

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
        case 'href':
          result.href = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ListSearchDto extends ListSearchDto {
  @override
  final String id;
  @override
  final String text;
  @override
  final String href;

  factory _$ListSearchDto([void Function(ListSearchDtoBuilder) updates]) =>
      (new ListSearchDtoBuilder()..update(updates)).build();

  _$ListSearchDto._({this.id, this.text, this.href}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('ListSearchDto', 'id');
    }
    if (text == null) {
      throw new BuiltValueNullFieldError('ListSearchDto', 'text');
    }
    if (href == null) {
      throw new BuiltValueNullFieldError('ListSearchDto', 'href');
    }
  }

  @override
  ListSearchDto rebuild(void Function(ListSearchDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListSearchDtoBuilder toBuilder() => new ListSearchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListSearchDto &&
        id == other.id &&
        text == other.text &&
        href == other.href;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, id.hashCode), text.hashCode), href.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ListSearchDto')
          ..add('id', id)
          ..add('text', text)
          ..add('href', href))
        .toString();
  }
}

class ListSearchDtoBuilder
    implements Builder<ListSearchDto, ListSearchDtoBuilder> {
  _$ListSearchDto _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _text;
  String get text => _$this._text;
  set text(String text) => _$this._text = text;

  String _href;
  String get href => _$this._href;
  set href(String href) => _$this._href = href;

  ListSearchDtoBuilder();

  ListSearchDtoBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _text = _$v.text;
      _href = _$v.href;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListSearchDto other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ListSearchDto;
  }

  @override
  void update(void Function(ListSearchDtoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ListSearchDto build() {
    final _$result =
        _$v ?? new _$ListSearchDto._(id: id, text: text, href: href);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

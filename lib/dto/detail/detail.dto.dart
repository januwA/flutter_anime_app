library detail.dto;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:anime_app/dto/detail/serializers.dart';
import 'package:anime_app/dto/li_data/li_data.dart';

part 'detail.dto.g.dart';

abstract class DetailDto implements Built<DetailDto, DetailDtoBuilder> {
  DetailDto._();

  factory DetailDto([updates(DetailDtoBuilder b)]) = _$DetailDto;

  @BuiltValueField(wireName: 'cover')
  String get cover;
  @BuiltValueField(wireName: 'videoName')
  String get videoName;
  @BuiltValueField(wireName: 'curentText')
  String get curentText;
  @BuiltValueField(wireName: 'starring')
  BuiltList<String> get starring;
  @BuiltValueField(wireName: 'director')
  String get director;
  @BuiltValueField(wireName: 'types')
  BuiltList<String> get types;
  @BuiltValueField(wireName: 'area')
  String get area;
  @BuiltValueField(wireName: 'years')
  String get years;
  @BuiltValueField(wireName: 'plot')
  String get plot;
  @BuiltValueField(wireName: 'tabs')
  BuiltList<String> get tabs;

  @BuiltValueField(wireName: 'tabsValues')
  BuiltList<TabsDto> get tabsValues;

  @BuiltValueField(wireName: 'listUnstyledTitle')
  BuiltList<String> get listUnstyledTitle;

  @BuiltValueField(wireName: 'listUnstyled')
  BuiltList<ListUnstyledItem> get listUnstyled;

  String toJson() {
    return jsonEncode(serializers.serializeWith(DetailDto.serializer, this));
  }

  static DetailDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        DetailDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<DetailDto> get serializer => _$detailDtoSerializer;
}

abstract class TabsDto implements Built<TabsDto, TabsDtoBuilder> {
  TabsDto._();

  factory TabsDto([updates(TabsDtoBuilder b)]) = _$TabsDto;

  @BuiltValueField(wireName: 'tabs')
  BuiltList<TabsValueDto> get tabs;
  String toJson() {
    return jsonEncode(serializers.serializeWith(TabsDto.serializer, this));
  }

  static TabsDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        TabsDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<TabsDto> get serializer => _$tabsDtoSerializer;
}

abstract class TabsValueDto
    implements Built<TabsValueDto, TabsValueDtoBuilder> {
  TabsValueDto._();

  factory TabsValueDto([updates(TabsValueDtoBuilder b)]) = _$TabsValueDto;

  @BuiltValueField(wireName: 'id')
  String get id;
  @BuiltValueField(wireName: 'text')
  String get text;
  @BuiltValueField(wireName: 'boxUrl')
  String get boxUrl;
  String toJson() {
    return jsonEncode(serializers.serializeWith(TabsValueDto.serializer, this));
  }

  static TabsValueDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        TabsValueDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<TabsValueDto> get serializer => _$tabsValueDtoSerializer;
}

/// ListUnstyledItem
abstract class ListUnstyledItem
    implements Built<ListUnstyledItem, ListUnstyledItemBuilder> {
  ListUnstyledItem._();

  factory ListUnstyledItem([updates(ListUnstyledItemBuilder b)]) =
      _$ListUnstyledItem;

  @nullable
  @BuiltValueField(wireName: 'item')
  BuiltList<LiData> get item;

  String toJson() {
    return jsonEncode(
        serializers.serializeWith(ListUnstyledItem.serializer, this));
  }

  static ListUnstyledItem fromJson(String jsonString) {
    return serializers
        .deserializeWith(ListUnstyledItem.serializer, jsonDecode(jsonString))
        .rebuild((b) => b..item ??= ListBuilder<LiData>());
  }

  static List<ListUnstyledItem> fromListJson(String jsonString) {
    return jsonDecode(jsonString)
        .map<ListUnstyledItem>((e) => fromJson(jsonEncode(e)))
        .toList();
  }

  static Serializer<ListUnstyledItem> get serializer =>
      _$listUnstyledItemSerializer;
}

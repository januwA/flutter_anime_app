library detail_data_dto;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_video_app/models/detail_data_dto/serializers.dart';

part 'detail_data_dto.g.dart';

abstract class DetailDataDto
    implements Built<DetailDataDto, DetailDataDtoBuilder> {
  DetailDataDto._();

  factory DetailDataDto([updates(DetailDataDtoBuilder b)]) = _$DetailDataDto;

  @BuiltValueField(wireName: 'detailData')
  DetailData get detailData;
  String toJson() {
    return json
        .encode(serializers.serializeWith(DetailDataDto.serializer, this));
  }

  static DetailDataDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        DetailDataDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<DetailDataDto> get serializer => _$detailDataDtoSerializer;
}

abstract class DetailData implements Built<DetailData, DetailDataBuilder> {
  DetailData._();

  factory DetailData([updates(DetailDataBuilder b)]) = _$DetailData;

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
  @BuiltValueField(wireName: 'playUrlTab')
  BuiltList<PlayUrlTab> get playUrlTab;
  String toJson() {
    return jsonEncode(serializers.serializeWith(DetailData.serializer, this));
  }

  static DetailData fromJson(String jsonString) {
    return serializers.deserializeWith(
        DetailData.serializer, jsonDecode(jsonString));
  }

  static Serializer<DetailData> get serializer => _$detailDataSerializer;
}

abstract class PlayUrlTab implements Built<PlayUrlTab, PlayUrlTabBuilder> {
  PlayUrlTab._();

  factory PlayUrlTab([updates(PlayUrlTabBuilder b)]) = _$PlayUrlTab;

  @BuiltValueField(wireName: 'id')
  String get id;
  @BuiltValueField(wireName: 'text')
  String get text;
  @BuiltValueField(wireName: 'isBox')
  bool get isBox;
  @BuiltValueField(wireName: 'src')
  String get src;
  String toJson() {
    return jsonEncode(serializers.serializeWith(PlayUrlTab.serializer, this));
  }

  static PlayUrlTab fromJson(String jsonString) {
    return serializers.deserializeWith(
        PlayUrlTab.serializer, jsonDecode(jsonString));
  }

  static Serializer<PlayUrlTab> get serializer => _$playUrlTabSerializer;
}
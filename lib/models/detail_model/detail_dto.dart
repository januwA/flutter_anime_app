import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_video_app/models/detail_model/serializers.dart';

part 'detail_dto.g.dart';

abstract class DetailDto implements Built<DetailDto, DetailDtoBuilder> {
  DetailDto._();

  factory DetailDto([updates(DetailDtoBuilder b)]) = _$DetailDto;

  @BuiltValueField(wireName: 'err')
  int get err;
  @BuiltValueField(wireName: 'data')
  Data get data;
  String toJson() {
    return jsonEncode(serializers.serializeWith(DetailDto.serializer, this));
  }

  static DetailDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        DetailDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<DetailDto> get serializer => _$detailDtoSerializer;
}

abstract class Data implements Built<Data, DataBuilder> {
  Data._();

  factory Data([updates(DataBuilder b)]) = _$Data;

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
    return jsonEncode(serializers.serializeWith(Data.serializer, this));
  }

  static Data fromJson(String jsonString) {
    return serializers.deserializeWith(Data.serializer, jsonDecode(jsonString));
  }

  static Serializer<Data> get serializer => _$dataSerializer;
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

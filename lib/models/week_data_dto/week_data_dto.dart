library week_data_dto;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_video_app/models/week_data_dto/serializers.dart';

part 'week_data_dto.g.dart';

abstract class WeekDataDto implements Built<WeekDataDto, WeekDataDtoBuilder> {
  WeekDataDto._();

  factory WeekDataDto([updates(WeekDataDtoBuilder b)]) = _$WeekDataDto;

  @BuiltValueField(wireName: 'weekData')
  BuiltList<WeekData> get weekData;
  String toJson() {
    return jsonEncode(serializers.serializeWith(WeekDataDto.serializer, this));
  }

  static WeekDataDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        WeekDataDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<WeekDataDto> get serializer => _$weekDataDtoSerializer;
}

abstract class WeekData implements Built<WeekData, WeekDataBuilder> {
  WeekData._();

  factory WeekData([updates(WeekDataBuilder b)]) = _$WeekData;

  @BuiltValueField(wireName: 'index')
  int get index;
  @BuiltValueField(wireName: 'liData')
  BuiltList<LiData> get liData;
  String toJson() {
    return jsonEncode(serializers.serializeWith(WeekData.serializer, this));
  }

  static WeekData fromJson(String jsonString) {
    return serializers.deserializeWith(
        WeekData.serializer, jsonDecode(jsonString));
  }

  static Serializer<WeekData> get serializer => _$weekDataSerializer;
}

abstract class LiData implements Built<LiData, LiDataBuilder> {
  LiData._();

  factory LiData([updates(LiDataBuilder b)]) = _$LiData;

  @BuiltValueField(wireName: 'id')
  String get id;
  @BuiltValueField(wireName: 'title')
  String get title;
  @BuiltValueField(wireName: 'img')
  String get img;
  @BuiltValueField(wireName: 'current')
  String get current;
  String toJson() {
    return jsonEncode(serializers.serializeWith(LiData.serializer, this));
  }

  static LiData fromJson(String jsonString) {
    return serializers.deserializeWith(
        LiData.serializer, jsonDecode(jsonString));
  }

  static Serializer<LiData> get serializer => _$liDataSerializer;
}

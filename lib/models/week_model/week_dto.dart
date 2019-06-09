import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_video_app/models/week_model/serializers.dart';
part 'week_dto.g.dart';

abstract class WeekDto implements Built<WeekDto, WeekDtoBuilder> {
  WeekDto._();

  factory WeekDto([updates(WeekDtoBuilder b)]) = _$WeekDto;

  @BuiltValueField(wireName: 'err')
  int get err;
  @BuiltValueField(wireName: 'data')
  BuiltList<WeekData> get data;
  String toJson() {
    return jsonEncode(serializers.serializeWith(WeekDto.serializer, this));
  }

  static WeekDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        WeekDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<WeekDto> get serializer => _$weekDtoSerializer;
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

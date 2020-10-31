library week_data_dto;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_video_app/dto/li_data/li_data.dart';
import 'package:flutter_video_app/dto/week_data/serializers.dart';

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

  static List<WeekData> fromListJson(String jsonString) {
    return jsonDecode(jsonString)
        .map<WeekData>((e) => fromJson(jsonEncode(e)))
        .toList();
  }

  static Serializer<WeekData> get serializer => _$weekDataSerializer;
}

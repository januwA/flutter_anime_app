
library li_data;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'serializers.dart';

part 'li_data.g.dart';

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

  @BuiltValueField(wireName: 'isNew')
  bool get isNew;

  String toJson() {
    return jsonEncode(serializers.serializeWith(LiData.serializer, this));
  }

  static LiData fromJson(String jsonString) {
    return serializers.deserializeWith(
        LiData.serializer, jsonDecode(jsonString));
  }

  static List<LiData> fromListJson(String jsonString) {
    return jsonDecode(jsonString).map<LiData>((e) => fromJson(jsonEncode(e))).toList();
  }

  static Serializer<LiData> get serializer => _$liDataSerializer;
}
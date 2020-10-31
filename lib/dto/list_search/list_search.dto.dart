library list_search_dto;

import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_video_app/dto/list_search/serializers.dart';

part 'list_search.dto.g.dart';

abstract class ListSearchDto
    implements Built<ListSearchDto, ListSearchDtoBuilder> {
  ListSearchDto._();

  factory ListSearchDto([updates(ListSearchDtoBuilder b)]) = _$ListSearchDto;

  @BuiltValueField(wireName: 'id')
  String get id;

  @BuiltValueField(wireName: 'text')
  String get text;

  @BuiltValueField(wireName: 'href')
  String get href;

  String toJson() {
    return jsonEncode(
        serializers.serializeWith(ListSearchDto.serializer, this));
  }

  static ListSearchDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        ListSearchDto.serializer, jsonDecode(jsonString));
  }

  static List<ListSearchDto> fromListJson(String jsonString) {
    return jsonDecode(jsonString)
        .map<ListSearchDto>((e) => fromJson(jsonEncode(e)))
        .toList();
  }

  static Serializer<ListSearchDto> get serializer => _$listSearchDtoSerializer;
}

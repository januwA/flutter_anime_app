import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_video_app/models/detail_data_dto/detail_data_dto.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  DetailDataDto
])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
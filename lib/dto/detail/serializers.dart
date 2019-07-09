import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_video_app/dto/detail/detail.dto.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  DetailDto
])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_video_app/dto/list_search/list_search.dto.dart';

part 'serializers.g.dart';

@SerializersFor(const [ListSearchDto])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

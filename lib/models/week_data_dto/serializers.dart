import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';

part 'serializers.g.dart';

@SerializersFor(const [WeekDataDto])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

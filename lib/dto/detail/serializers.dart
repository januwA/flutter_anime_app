import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:anime_app/dto/detail/detail.dto.dart';
import 'package:anime_app/dto/li_data/li_data.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  DetailDto,LiData
])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
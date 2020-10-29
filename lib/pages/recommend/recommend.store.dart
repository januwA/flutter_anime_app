import 'package:flutter_video_app/dto/li_data/li_data.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/service/nicotv.service.dart';
import 'package:mobx/mobx.dart';
part 'recommend.store.g.dart';

class RecommendStore extends _RecommendStore with _$RecommendStore {
  static RecommendStore _cache;

  RecommendStore._();

  factory RecommendStore() {
    _cache ??= RecommendStore._();
    return _cache;
  }
}

abstract class _RecommendStore with Store {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入
  _RecommendStore() {
    _getData();
  }

  @observable
  List<LiData> animeList;

  @action
  Future<void> _getData() async {
    animeList = await nicoTvService.getRecommendAnimes();
  }

  @action
  Future<void> refresh() async {
    animeList = null;
    _getData();
  }
}

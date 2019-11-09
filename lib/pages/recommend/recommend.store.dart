import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/shared/nicotv.service.dart';
import 'package:mobx/mobx.dart';
part 'recommend.store.g.dart';

class RecommendStore = _RecommendStore with _$RecommendStore;

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

import 'package:flutter_video_app/dto/week_data/week_data_dto.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/shared/nicotv.service.dart';
import 'package:mobx/mobx.dart';
part 'recently_updated.store.g.dart';

class RecentlyUpdatedStore = _RecentlyUpdatedStore with _$RecentlyUpdatedStore;

abstract class _RecentlyUpdatedStore with Store {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入
  _RecentlyUpdatedStore() {
    _getData();
  }

  @observable
  List<LiData> animeList;

  /// 由于没有id，全是一样的class
  /// 先获取标题
  /// 在获取兄弟节点
  @action
  Future<void> _getData() async {
    animeList = await nicoTvService.getRecentlyUpdatedAnimes();
  }

  @action
  Future<void> refresh() async {
    animeList = null;
    _getData();
  }
}

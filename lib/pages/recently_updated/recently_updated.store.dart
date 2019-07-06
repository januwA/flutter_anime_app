import 'package:built_collection/built_collection.dart';
import 'package:flutter_video_app/utils/anime_list.dart';
import 'package:flutter_video_app/utils/jquery.dart';
import 'package:html/dom.dart' as dom;
import 'package:mobx/mobx.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
part 'recently_updated.store.g.dart';

class RecentlyUpdatedStore = _RecentlyUpdatedStore with _$RecentlyUpdatedStore;

abstract class _RecentlyUpdatedStore with Store {
  _RecentlyUpdatedStore() {
    getData();
  }

  @observable
  BuiltList<LiData> animeList;

  /// 由于没有id，全是一样的class
  /// 先获取标题
  /// 在获取兄弟节点

  @action
  Future<void> getData() async {
    dom.Document document = await $document('http://www.nicotv.me');

    /// 获取所有标题元素
    List<dom.Element> headers = $$(document, '.page-header');

    /// 所有元素的 text
    int index = headers.indexWhere((el) => el.innerHtml.contains('最近更新'));

    /// 找到兄弟元素 获取数据
    dom.Element dataEles =
        $(headers[index].nextElementSibling, 'div.col-md-8>ul.list-unstyled');

    List<dom.Element> list = $$(dataEles, 'li');
    BuiltList<LiData> aList = createAnimeList(list);
    animeList = aList;
  }
}

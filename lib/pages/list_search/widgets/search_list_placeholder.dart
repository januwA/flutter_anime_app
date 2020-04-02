import 'package:flutter/material.dart';
import 'package:flutter_video_app/dto/list_search/list_search.dto.dart';
import 'package:flutter_video_app/main.dart';
import 'package:flutter_video_app/router/router.dart';
import 'package:flutter_video_app/shared/nicotv.service.dart';

/// 使用全局变量缓存列表
/// 懒惰加载
List<ListSearchDto> _listData;

class SearchListPlaceholder extends StatefulWidget {
  @override
  _SearchListPlaceholderState createState() => _SearchListPlaceholderState();
}

class _SearchListPlaceholderState extends State<SearchListPlaceholder> {
  final NicoTvService nicoTvService = getIt<NicoTvService>(); // 注入
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() => loading = true);
    _listData ??= await nicoTvService.getSearchListPlaceholder();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : _popularSearches();
  }

  _popularSearches() {
    return ListView(
      children: [
        ListTile(
          title: Text(
            '热门搜索：',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        for (ListSearchDto data in _listData)
          ListTile(
            onTap: () {
              router.pushNamed('/anime-detail/${data.id}');
            },
            title: Text(data.text),
            trailing: IconButton(
              onPressed: () {
                String url = 'http://www.nicotv.me${data.href}';
                router.pushNamed('/nicotv', arguments: url);
              },
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.open_in_new),
            ),
          )
      ],
    );
  }
}

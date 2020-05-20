import 'package:flutter/material.dart';

import 'widgets/list_results.dart';
import 'widgets/search_list_placeholder.dart';

class ListSearchPage extends SearchDelegate<String> {
  ListSearchPage()
      : super(
          searchFieldLabel: 'Search Anime Name',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  /// 用户从搜索页面提交搜索后显示的结果
  @override
  Widget buildResults(BuildContext context) => ListResults(query: query);

  /// 当用户在搜索字段中键入查询时，在搜索页面正文中显示的建议
  @override
  Widget buildSuggestions(BuildContext context) => SearchListPlaceholder();
}

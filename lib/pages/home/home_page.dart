import 'package:flutter/material.dart';
import 'package:flutter_video_app/anime_localizations.dart';
import 'package:flutter_video_app/pages/home/home.store.dart';
import 'package:flutter_video_app/pages/home/widgets/home_drawer.dart';
import 'package:flutter_video_app/pages/list_search/list_search.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/shared/widgets/anime_grid_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final HomeStore store = HomeStore();

  @override
  void initState() {
    super.initState();
    store.initState(this);
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final week = <String>[
      AnimeLocalizations.of(context).monday,
      AnimeLocalizations.of(context).tuesday,
      AnimeLocalizations.of(context).wednesday,
      AnimeLocalizations.of(context).thursday,
      AnimeLocalizations.of(context).friday,
      AnimeLocalizations.of(context).saturday,
      AnimeLocalizations.of(context).sunday,
    ];
    final tabs = week.map((w) => Tab(text: w)).toList();
    return Observer(
      builder: (_) {
        return Scaffold(
          drawer: HomeDrawer(),
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    // pinned: true,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    title: Text(AnimeLocalizations.of(context).homeTitle),
                    actions: _buildActions(),
                    bottom: TabBar(
                      isScrollable: true,
                      controller: store.tabController,
                      tabs: tabs,
                    ),
                  ),
                ),
              ];
            },
            body: store.isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: store.tabController,
                    children: [
                      for (var data in store.weekData)
                        RefreshIndicator(
                          onRefresh: store.refresh,
                          child: AnimeGridView(
                            key: PageStorageKey<int>(data.index),
                            animes: data.liData.toList(),
                          ),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  List<Widget> _buildActions() {
    return [
      Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              showSearch<String>(
                context: context,
                delegate: ListSearchPage(),
              );
            },
          );
        },
      ),
    ];
  }
}

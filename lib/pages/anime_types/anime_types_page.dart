import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/anime_localizations.dart';
import 'package:flutter_video_app/pages/anime_types/anime_types.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_grid_view.dart';
import 'package:flutter_video_app/utils/debounce.dart';

class AnimeTypesPage extends StatefulWidget {
  @override
  _AnimeTypesPageState createState() => _AnimeTypesPageState();
}

class _AnimeTypesPageState extends State<AnimeTypesPage>
    with TickerProviderStateMixin {
  final AnimeTypesStore store = AnimeTypesStore();
  @override
  void initState() {
    super.initState();
    store.initState(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  Widget _createTab(controller, List<String> data, {Function(int) onTap}) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: TabBar(
        indicatorColor: Colors.white,
        controller: controller,
        isScrollable: true,
        tabs: data.map((String t) => Tab(text: t)).toList(),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var types = [
      AnimeLocalizations.of(context).all,
      AnimeLocalizations.of(context).types2,
      AnimeLocalizations.of(context).types3,
      AnimeLocalizations.of(context).types4,
      AnimeLocalizations.of(context).types5,
      AnimeLocalizations.of(context).types6,
      AnimeLocalizations.of(context).types7,
      AnimeLocalizations.of(context).types8,
      AnimeLocalizations.of(context).types9,
      AnimeLocalizations.of(context).types10,
      AnimeLocalizations.of(context).types11,
      AnimeLocalizations.of(context).types12,
      AnimeLocalizations.of(context).types13,
      AnimeLocalizations.of(context).types14,
      AnimeLocalizations.of(context).types15,
      AnimeLocalizations.of(context).types16,
    ];
    List<String> eras = [
      AnimeLocalizations.of(context).all,
      "2020",
      "2019",
      "2018",
      "2017",
      "2016",
      "2015",
      "2014",
      "2013",
      "2010-2000",
      "90年代",
      AnimeLocalizations.of(context).earlier
    ];
    List<String> classify = [
      AnimeLocalizations.of(context).classifyTabsRecentlyBroadcasted,
      AnimeLocalizations.of(context).classifyTabsNewest,
      AnimeLocalizations.of(context).classifyTabsHighestScore,
    ];
    return SafeArea(
      child: Scaffold(
        body: NotificationListener(
          onNotification: store.onNotification,
          child: CustomScrollView(
            controller: store.scrollCtrl,
            key: PageStorageKey('anime_types'),
            slivers: <Widget>[
              SliverSafeArea(
                sliver: SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 230,
                  floating: true,
                  backgroundColor: Colors.grey[100],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _createTab(
                          store.tabTypesCtrl,
                          types,
                          onTap: debounce(store.setTypesCurrent),
                        ),
                        SizedBox(height: 10),
                        _createTab(
                          store.tabAreasCtrl,
                          store.areas,
                          onTap: debounce(store.setAreasCurrent),
                        ),
                        SizedBox(height: 10),
                        _createTab(
                          store.tabErasCtrl,
                          eras,
                          onTap: debounce(store.setErasCurrent),
                        ),
                        SizedBox(height: 10),
                        _createTab(
                          store.tabClassifyCtrl,
                          classify,
                          onTap: debounce(store.setClassifyCurrent),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Observer(
                builder: (_) => store.loading && store.animeData.isEmpty
                    ? SliverToBoxAdapter()
                    : store.animeData.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(AnimeLocalizations.of(context).notData),
                            )),
                          )
                        : AnimeGridView(
                            key: ValueKey('anime_types'),
                            sliver: true,
                            animes: store.animeData,
                          ),
              ),
              Observer(
                builder: (_) => SliverToBoxAdapter(
                  child: Opacity(
                    opacity: store.loading ? 1 : 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

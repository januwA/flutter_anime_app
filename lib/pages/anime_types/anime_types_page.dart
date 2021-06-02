import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:anime_app/pages/anime_types/anime_types.store.dart';
import 'package:anime_app/shared/widgets/anime_grid_view.dart';
import 'package:anime_app/utils/debounce.dart';

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
    // anime 类型
    var types = [
      AppLocalizations.of(context).all,
      AppLocalizations.of(context).types2,
      AppLocalizations.of(context).types3,
      AppLocalizations.of(context).types4,
      AppLocalizations.of(context).types5,
      AppLocalizations.of(context).types6,
      AppLocalizations.of(context).types7,
      AppLocalizations.of(context).types8,
      AppLocalizations.of(context).types9,
      AppLocalizations.of(context).types10,
      AppLocalizations.of(context).types11,
      AppLocalizations.of(context).types12,
      AppLocalizations.of(context).types13,
      AppLocalizations.of(context).types14,
      AppLocalizations.of(context).types15,
      AppLocalizations.of(context).types16,
    ];

    // 年代
    List<String> yras = [
      AppLocalizations.of(context).all,
      "2021",
      "2020",
      "2019",
      "2018",
      "2017",
      "2016",
      "2015",
      "2014",
      "2013",
      "2012",
      "2010-2000",
      "90年代",
      AppLocalizations.of(context).earlier
    ];

    // 地区
    List<String> areas = [
      AppLocalizations.of(context).all,
      AppLocalizations.of(context).japan,
      AppLocalizations.of(context).china,
      AppLocalizations.of(context).america,
      AppLocalizations.of(context).other,
    ];

    List<String> classify = [
      AppLocalizations.of(context).hits,
      AppLocalizations.of(context).newest,
      AppLocalizations.of(context).gold,
    ];
    return SafeArea(
      child: Scaffold(
        body: NotificationListener(
          onNotification: store.onNotification,
          child: CupertinoScrollbar(
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
                            areas,
                            onTap: debounce(store.setAreasCurrent),
                          ),
                          SizedBox(height: 10),
                          _createTab(
                            store.tabErasCtrl,
                            yras,
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
                                    Text(AppLocalizations.of(context).notData),
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
      ),
    );
  }
}

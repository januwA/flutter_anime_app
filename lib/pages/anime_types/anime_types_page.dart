import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/anime_types/anime_types.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_video_app/utils/debounce.dart';

AnimeTypesStore store = AnimeTypesStore();

class AnimeTypesPage extends StatefulWidget {
  @override
  _AnimeTypesPageState createState() => _AnimeTypesPageState();
}

class _AnimeTypesPageState extends State<AnimeTypesPage>
    with TickerProviderStateMixin {
  TabController _tabTypesCtrl;
  TabController _tabAreasCtrl;
  TabController _tabErasCtrl;
  TabController _tabClassifyCtrl;
  ScrollController _strollCtrl = ScrollController();
  @override
  void initState() {
    super.initState();
    _tabTypesCtrl = TabController(
      vsync: this,
      length: store.types.length,
      initialIndex: store.typesCurrent,
    );
    _tabAreasCtrl = TabController(
      vsync: this,
      length: store.areas.length,
      initialIndex: store.areasCurrent,
    );

    _tabErasCtrl = TabController(
      vsync: this,
      length: store.eras.length,
      initialIndex: store.erasCurrent,
    );
    _tabClassifyCtrl = TabController(
      vsync: this,
      length: store.classify.length,
      initialIndex: store.classifyCurrent,
    );
    _strollCtrl.addListener(() {
      if (_strollCtrl.position.pixels == _strollCtrl.position.maxScrollExtent) {
        if (store.loading) return;
        store.setPageCount(store.pageCount + 1);
        store.getData();
      }
    });
  }

  @override
  void dispose() {
    _tabTypesCtrl.dispose();
    _tabAreasCtrl.dispose();
    _tabClassifyCtrl.dispose();
    _tabErasCtrl.dispose();
    _strollCtrl.dispose();
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
    return Scaffold(
      body: CustomScrollView(
        key: PageStorageKey('anime_types'),
        controller: _strollCtrl,
        slivers: <Widget>[
          SliverSafeArea(
            sliver: SliverAppBar(
              expandedHeight: 230,
              floating: true,
              backgroundColor: Colors.grey[100],
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _createTab(
                      _tabTypesCtrl,
                      store.types,
                      onTap: debounce(store.setTypesCurrent),
                    ),
                    SizedBox(height: 10),
                    _createTab(
                      _tabAreasCtrl,
                      store.areas,
                      onTap: debounce(store.setAreasCurrent),
                    ),
                    SizedBox(height: 10),
                    _createTab(
                      _tabErasCtrl,
                      store.eras,
                      onTap: debounce(store.setErasCurrent),
                    ),
                    SizedBox(height: 10),
                    _createTab(
                      _tabClassifyCtrl,
                      store.classify.map((c) => c.text).toList(),
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
                          child: Text('Not Data!'),
                        )),
                      )
                    : SliverGrid.count(
                        crossAxisCount: 2, // 每行显示几列
                        mainAxisSpacing: 2.0, // 每行的上下间距
                        crossAxisSpacing: 2.0, // 每列的间距
                        childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                        children: <Widget>[
                          for (var anime in store.animeData)
                            AnimeCard(
                              key: ObjectKey(anime),
                              animeData: anime,
                            )
                        ],
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
    );
  }
}

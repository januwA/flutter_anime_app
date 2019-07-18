import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_video_app/pages/anime_types/anime_types.store.dart';
import 'package:flutter_video_app/shared/widgets/anime_card.dart';
import 'package:flutter_video_app/utils/debounce.dart';

class AnimeTypesPage extends StatefulWidget {
  @override
  _AnimeTypesPageState createState() => _AnimeTypesPageState();
}

class _AnimeTypesPageState extends State<AnimeTypesPage>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<AnimeTypesPage> {
  AnimeTypesStore store = AnimeTypesStore();
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
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          controller: store.strollCtrl,
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
                        store.types,
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
                        store.eras,
                        onTap: debounce(store.setErasCurrent),
                      ),
                      SizedBox(height: 10),
                      _createTab(
                        store.tabClassifyCtrl,
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_video_app/models/week_data_dto/week_data_dto.dart';
import 'package:flutter_video_app/pages/detail/detail_page.dart';
import 'package:flutter_video_app/pages/home/home.store.dart';
import 'package:flutter_video_app/shared/widgets/http_loading_page.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

final homeStore = HomeStore();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(
        vsync: this,
        initialIndex: homeStore.initialIndex,
        length: homeStore.week.length);
    tabController.addListener(() {
      homeStore.setInitialIndex(tabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => homeStore.isLoading
          ? HttpLoadingPage(title: '追番表 ')
          : Scaffold(
              appBar: AppBar(
                title: Text('追番表'),
                bottom: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabs: homeStore.week.map((w) => Tab(text: w)).toList(),
                ),
              ),
              body: TabBarView(
                controller: tabController,
                children: [
                  for (WeekData data in homeStore.weekData)
                    GridView.count(
                      // PageStorageKey: 保存页面的滚动状态，nice
                      key: PageStorageKey<int>(data.index),
                      crossAxisCount: 2, // 每行显示几列
                      mainAxisSpacing: 2.0, // 每行的上下间距
                      crossAxisSpacing: 2.0, // 每列的间距
                      childAspectRatio: 0.6, //每个孩子的横轴与主轴范围的比率
                      children: <Widget>[
                        for (var li in data.liData) AnimeCard(animeData: li),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}

/// 每个anime的展示卡片
class AnimeCard extends StatelessWidget {
  AnimeCard({
    @required this.animeData,
  });

  final LiData animeData;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(animeId: animeData.id))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  animeData.img,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
            ListTile(
              title: Text(
                animeData.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Text(animeData.current),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter_ajanuw_router/ajanuw_route.dart';
import 'package:flutter_ajanuw_router/flutter_ajanuw_router.dart';
import 'package:flutter_video_app/pages/collections/collections_page.dart';
import 'package:flutter_video_app/pages/dash/dash_page.dart';
import 'package:flutter_video_app/pages/detail/detail_page.dart';
import 'package:flutter_video_app/pages/detail/widgets/full_play_web_video.dart';
import 'package:flutter_video_app/pages/history/history_page.dart';
import 'package:flutter_video_app/pages/nicotv/nicotv_page.dart';
import 'package:flutter_video_app/pages/not_found/not_found.page.dart';

AjanuwRouter router = AjanuwRouter();
final List<AjanuwRoute> routes = [
  AjanuwRoute(path: '', redirectTo: '/dash'),
  AjanuwRoute(
    path: 'dash',
    builder: (c, r) => DashPage(),
  ),

  // 收藏列表
  AjanuwRoute(
    path: 'collections',
    builder: (c, r) => CollectionsPage(),
  ),

  // 历史记录
  AjanuwRoute(
    path: 'history',
    builder: (c, r) => HistoryPage(),
  ),
  AjanuwRoute(
    path: 'anime-detail/:id',
    builder: (c, r) => DetailPage(animeId: r.paramMap['id']),
  ),
  AjanuwRoute(
    path: 'full-webvideo',
    builder: (c, r) => FullPlayWebVideo(initialUrl: r.arguments),
  ),
  AjanuwRoute(
    path: 'nicotv',
    builder: (c, r) =>
        r.arguments == null ? NicotvPage() : NicotvPage(url: r.arguments),
  ),

  AjanuwRoute(
    path: 'not-found',
    builder: (c, r) => NotFoundPage(),
  ),
  AjanuwRoute(
    path: '**',
    redirectTo: '/not-found',
  ),
];

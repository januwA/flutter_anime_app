import 'package:flutter/material.dart';
import 'package:flutter_imagenetwork/flutter_imagenetwork.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:anime_app/main.dart';
import 'package:anime_app/service/history.service.dart';
import 'package:anime_app/router/router.dart';
import 'package:anime_app/sqflite_db/model/history.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:anime_app/utils/duration_string.dart';
import 'package:anime_app/utils/history_time_offset.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService historyService = getIt<HistoryService>();

  TextStyle get _textRichStyle =>
      Theme.of(context).textTheme.caption.copyWith(color: Colors.grey[600]);

  bool loading = true;
  List<History> historys = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  /// 初始化记录
  void _initData() async {
    var _historys = await historyService.historys;
    setState(() {
      historys = _historys;
      loading = false;
    });
  }

  /// 删除记录
  void _delete(History h) {
    historyService.delete(h);
    setState(() {
      historys.remove(h);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).historicalRecord),
      ),
      body: Center(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : _buildList(historys),
      ),
    );
  }

  _buildList(List<History> historys) {
    if (historys.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).notData));
    }

    return ListView.builder(
      itemExtent: 110, // 每个子项的高度
      itemCount: historys.length,
      itemBuilder: (content, int index) {
        var h = historys[index];
        return Slidable(
          key: ValueKey(h.id),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.2,
          child: InkWell(
            onTap: () {
              router.pushNamed('/anime-detail/${h.animeId}');
            },
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /// left image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: AspectRatio(
                      aspectRatio: 5 / 5,
                      child: AjanuwImage(
                        image: AjanuwNetworkImage(h.cover),
                        fit: BoxFit.fitWidth,
                        frameBuilder: AjanuwImage.defaultFrameBuilder,
                      ),
                    ),
                  ),

                  /// right
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(h.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText2),
                          Spacer(),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        '${h.playCurrent.isEmpty ? "第0集" : h.playCurrent}'),
                                TextSpan(text: '  '),
                                TextSpan(
                                    text: durationString(
                                        Duration(seconds: h.position))),
                                TextSpan(text: ' / '),
                                TextSpan(
                                    text: durationString(
                                        Duration(seconds: h.duration)))
                              ],
                            ),
                            style: _textRichStyle,
                          ),
                          Text(historyTimeOffset(h.time),
                              style: _textRichStyle),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          secondaryActions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: IconSlideAction(
                caption: 'delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => _delete(h),
              ),
            ),
          ],
        );
      },
    );
  }
}

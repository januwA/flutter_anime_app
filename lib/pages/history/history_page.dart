import 'package:flutter/material.dart';
import 'package:flutter_video_app/db/app_database.dart';
import 'package:flutter_video_app/pages/detail/detail_page.dart';
import 'package:flutter_video_app/store/main/main.store.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_video_app/utils/duration_string.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = '/HistoryPage';
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _createTimeString(DateTime t) {
    var now = DateTime.now();
    if (t.year == now.year && t.month == now.month && t.day == now.day) {
      return '今天';
    } else {
      String day = t.day < 10 ? '0${t.day}' : '${t.day}';
      String hour = t.hour < 10 ? '0${t.hour}' : '${t.hour}';
      String minute = t.minute < 10 ? '0${t.minute}' : '${t.minute}';

      return '${t.year}-${t.month}-$day $hour:$minute';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('历史记录'),
      ),
      body: Center(
        child: StreamBuilder<List<History>>(
          stream: mainStore.historyService.historys$,
          builder: (context, AsyncSnapshot<List<History>> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snap.connectionState == ConnectionState.active) {
              if (snap.hasError) {
                return Center(child: Text('${snap.error}'));
              }
              List<History> historys = snap.data;
              if (historys.isEmpty) {
                return Center(child: Text('Not Data!'));
              }
              return ListView.builder(
                itemCount: historys.length,
                itemBuilder: (content, int index) {
                  var h = historys[index];
                  return Container(
                    margin: EdgeInsets.all(6.0),
                    child: Slidable(
                      key: ValueKey(h.id),
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.2,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(animeId: h.animeId),
                          ));
                        },
                        child: Container(
                          height: 100,
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(4.0),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 3.2,
                                    child: Image.network(
                                      h.cover,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              h.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          '${h.playCurrent.isEmpty ? "第0集" : h.playCurrent}'),
                                                  TextSpan(text: '  '),
                                                  TextSpan(
                                                      text: durationString(
                                                          Duration(
                                                              seconds:
                                                                  h.position))),
                                                  TextSpan(text: ' / '),
                                                  TextSpan(
                                                      text: durationString(
                                                          Duration(
                                                              seconds:
                                                                  h.duration)))
                                                ],
                                              ),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body2
                                                  .copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: _createTimeString(
                                                      h.time)),
                                              TextSpan(text: ' '),
                                            ],
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => mainStore.historyService.delete(h),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

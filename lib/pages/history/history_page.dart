import 'package:flutter/material.dart';
import 'package:flutter_video_app/db/app_database.dart';
import 'package:flutter_video_app/pages/detail/detail_page.dart';
import 'package:flutter_video_app/shared/widgets/one_line_text.dart';
import 'package:flutter_video_app/store/main/main.store.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      return '${t.year}-${t.month}-${t.day} ${t.hour}:${t.minute}';
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
              return ListView.builder(
                itemCount: historys.length,
                itemBuilder: (content, int index) {
                  var h = historys[index];
                  return Slidable(
                    key: ValueKey(h.id),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 6 / 4,
                          child: Image.network(
                            h.cover,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: TwoLineText(h.title),
                        subtitle: Text(
                            _createTimeString(h.time) + ' ${h.playCurrent.isEmpty ? "第0集" : h.playCurrent}'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(animeId: h.animeId)));
                        },
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

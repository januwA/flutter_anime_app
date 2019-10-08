import 'package:flutter/material.dart';
import 'package:flutter_video_app/router/router.dart';

/// 从服务器获取数据失败时，弹出提示框，提醒用户
Future<void> alertHttpGetError({
  @required BuildContext context,
  @required String text,
  String title = '错误请重试',
  Function onOk,
  String okText = "重试",
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              router.navigator.pop();
            },
          ),
          FlatButton(
            child: Text(okText),
            onPressed: () {
              router.navigator.pop();
              onOk != null && onOk();
            },
          ),
        ],
      );
    },
  );
}

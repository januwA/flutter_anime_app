import 'package:flutter/material.dart';

/// 从服务器获取数据失败时，弹出提示框，提醒用户
Future<void> alertHttpGetError({
  @required context,
  @required String text,
  String title = '错误请重试',
  Function onOk,
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
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text('重试'),
            onPressed: () {
              Navigator.of(ctx).pop();
              onOk();
            },
          ),
        ],
      );
    },
  );
}

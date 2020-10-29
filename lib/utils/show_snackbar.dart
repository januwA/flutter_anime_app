import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String content) {
  Scaffold.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 3),
    shape: RoundedRectangleBorder(),
    content: Text(content),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  ));
}

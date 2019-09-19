import 'package:flutter/material.dart';

class WrapText extends StatelessWidget {
  final String tag;
  final List<String> texts;

  const WrapText({Key key, this.tag, this.texts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: <Widget>[
        Text('$tag:'),
        for (String name in texts) Text(name),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class WrapText extends StatelessWidget {
  final String tag;
  final List<String> texts;

  const WrapText({Key key, this.tag, this.texts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(
          tag,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        for (String t in texts) Text(t),
      ],
    );
  }
}

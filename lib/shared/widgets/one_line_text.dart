import 'package:flutter/widgets.dart';

class TwoLineText extends Text {
  final int maxLines = 2;
  final TextOverflow overflow = TextOverflow.ellipsis;
  TwoLineText(String data) : super(data);
}

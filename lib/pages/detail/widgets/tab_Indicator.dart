import 'package:flutter/material.dart';

class TabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([onChanged]) {
    return _MyIndicator(this, onChanged);
  }
}

class _MyIndicator extends BoxPainter {
  _MyIndicator(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final TabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = offset & cfg.size;
    print(rect);
    var paint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;

    var path = Path()
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.bottomRight.dx - 4, rect.bottomRight.dy - 4)
      ..lineTo(rect.bottomRight.dx - 6, rect.bottomRight.dy - 6)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy - 2)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
    canvas.drawPath(path, paint);
  }
}

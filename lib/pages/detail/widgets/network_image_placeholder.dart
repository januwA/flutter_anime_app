import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_imagenetwork/flutter_imagenetwork.dart';

class NetworkImagePlaceholder extends StatelessWidget {
  final String src;

  const NetworkImagePlaceholder(this.src, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(src),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          color: Colors.white.withOpacity(0.1),
          child: Center(
            child: AjanuwImage(
              image: AjanuwNetworkImage(src),
              frameBuilder: AjanuwImage.defaultFrameBuilder,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

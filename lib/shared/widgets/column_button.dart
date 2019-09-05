import 'dart:math' as math;
import 'package:flutter/material.dart';

class ColumnButton extends StatelessWidget {
  final Icon icon;
  final Widget label;
  final Function onPressed;
  final Color color;
  final EdgeInsetsGeometry padding;
  final double iconSize;

  const ColumnButton({
    Key key,
    this.icon,
    this.label,
    this.onPressed,
    this.color,
    this.padding = const EdgeInsets.all(8.0),
    this.iconSize = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: iconSize,
          width: iconSize,
          child: Align(
            alignment: Alignment.center,
            child: IconTheme.merge(
              data: IconThemeData(
                size: iconSize,
                color: color,
              ),
              child: icon,
            ),
          ),
        ),
        label,
      ],
    );

    return Padding(
      padding: padding,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        child: InkResponse(
          onTap: onPressed,
          child: result,
          focusColor: Theme.of(context).focusColor,
          hoverColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          splashColor: Theme.of(context).splashColor,
          radius: math.max(
            Material.defaultSplashRadius,
            (iconSize + math.min(padding.horizontal, padding.vertical)) * 0.7,
          ),
        ),
      ),
    );
  }
}

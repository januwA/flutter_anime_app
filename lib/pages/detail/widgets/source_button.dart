import 'package:flutter/material.dart';

class SourceButton extends StatelessWidget {
  final bool isActive;
  final Function() onPressed;
  final Widget child;
  SourceButton({
    this.isActive = false,
    this.onPressed,
    this.child,
  });

  final ShapeBorder shape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0));
  final __textTheme = ButtonTextTheme.primary;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      padding: EdgeInsets.all(4.0),
      child: isActive
          ? RaisedButton(
              shape: shape,
              textTheme: __textTheme,
              color: theme.primaryColor,
              onPressed: onPressed,
              child: child,
            )
          : OutlineButton(
              shape: shape,
              borderSide: BorderSide(color: theme.primaryColor),
              textTheme: __textTheme,
              onPressed: onPressed,
              child: child,
            ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final _btn_style = ButtonStyle(
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
      side: MaterialStateProperty.all(
        BorderSide(color: theme.primaryColor),
      ),
      textStyle: MaterialStateProperty.all(
        TextStyle(color: theme.primaryColor),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      padding: EdgeInsets.all(4.0),
      child: isActive
          ? ElevatedButton(
              style: _btn_style,
              onPressed: onPressed,
              child: child,
            )
          : OutlinedButton(
              style: _btn_style,
              onPressed: onPressed,
              child: child,
            ),
    );
  }
}

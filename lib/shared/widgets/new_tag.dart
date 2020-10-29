import 'package:flutter/material.dart';

class NewTag extends StatelessWidget {
  const NewTag();
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .95,
      child: Image.asset('assets/new_ico.png', scale: 1.5),
    );
  }
}

import 'package:flutter/material.dart';

class SliverLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SliverToBoxAdapter(
      child: Container(
        height: height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

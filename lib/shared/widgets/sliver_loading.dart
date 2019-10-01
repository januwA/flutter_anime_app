import 'package:flutter/material.dart';

class SliverLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Container(
        width: size.width,
        height: size.height - kBottomNavigationBarHeight - kToolbarHeight,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

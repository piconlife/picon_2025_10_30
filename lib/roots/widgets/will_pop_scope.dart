import 'package:flutter/material.dart';

typedef InAppWillPopCallback = Future<bool> Function();

class InAppWillPopScope extends StatelessWidget {
  final InAppWillPopCallback? onWillPop;
  final Widget child;

  const InAppWillPopScope({super.key, required this.child, this.onWillPop});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: onWillPop, child: child);
  }
}

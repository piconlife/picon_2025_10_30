import 'package:flutter/material.dart';

class InAppAutoScroll extends StatelessWidget {
  final ScrollController controller;
  final int targetIndex;
  final double itemHeight;
  final double adjustmentHeight;
  final Widget child;

  const InAppAutoScroll({
    super.key,
    required this.controller,
    required this.targetIndex,
    required this.itemHeight,
    this.adjustmentHeight = 0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (targetIndex <= 0) return child;
    return LayoutBuilder(
      builder: (context, constraints) {
        _scroll(constraints.maxHeight);
        return child;
      },
    );
  }

  void _scroll(double maxHeight) {
    if (targetIndex <= 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;
      double position =
          (targetIndex + 3) * itemHeight - (maxHeight - adjustmentHeight);
      if (position < 0) position = 0;
      controller.jumpTo(position);
    });
  }
}

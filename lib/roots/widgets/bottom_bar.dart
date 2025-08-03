import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';

class InAppBottomBar extends StatelessWidget {
  final Color? color;
  final double? height;
  final Widget child;

  const InAppBottomBar({
    super.key,
    this.color,
    this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? context.bottomColor.primary,
        border: Border(top: BorderSide(color: context.grey.t25, width: 1)),
        boxShadow: [BoxShadow(color: context.dark.t10, blurRadius: 50)],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 8,
          bottom: MediaQuery.maybePaddingOf(context)?.bottom ?? 4,
        ),
        child: SizedBox(height: height, child: child),
      ),
    );
  }
}

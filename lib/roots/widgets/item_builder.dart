import 'package:flutter/material.dart';

import 'layout.dart';

class InAppItemBuilder extends StatelessWidget {
  final Alignment alignment;
  final StackFit fit;
  final bool stacked;
  final double itemHeight;
  final Axis direction;
  final double spacing;
  final Clip clipBehavior;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline? textBaseline;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const InAppItemBuilder({
    super.key,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.clipBehavior = Clip.none,
    this.spacing = 0.0,
    required this.itemCount,
    required this.itemBuilder,
  }) : stacked = false,
       itemHeight = 0,
       alignment = Alignment.topLeft,
       fit = StackFit.loose;

  const InAppItemBuilder.stack({
    super.key,
    this.alignment = Alignment.topLeft,
    this.fit = StackFit.loose,
    this.textDirection,
    this.textBaseline,
    this.clipBehavior = Clip.none,
    this.spacing = 0.0,
    required this.itemHeight,
    required this.itemCount,
    required this.itemBuilder,
  }) : stacked = true,
       direction = Axis.vertical,
       mainAxisAlignment = MainAxisAlignment.start,
       crossAxisAlignment = CrossAxisAlignment.center,
       mainAxisSize = MainAxisSize.max,
       verticalDirection = VerticalDirection.down;

  @override
  Widget build(BuildContext context) {
    if (stacked) {
      return InAppLayout(
        layout: LayoutType.stack,
        alignment: alignment,
        fit: fit,
        clipBehavior: clipBehavior,
        textDirection: textDirection,
        children: List.generate(itemCount, (index) {
          Widget child = itemBuilder(context, index);
          if (itemHeight > 0 && index > 0) {
            child = Padding(
              padding: EdgeInsets.only(top: ((itemHeight + spacing) * index)),
              child: child,
            );
            child = child;
          }
          return child;
        }),
      );
    }
    return InAppLayout(
      clipBehavior: clipBehavior,
      crossAxisAlignment: crossAxisAlignment,
      layout: direction == Axis.horizontal ? LayoutType.row : LayoutType.column,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      spacing: spacing,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: List.generate(itemCount, (index) {
        return itemBuilder(context, index);
      }),
    );
  }
}

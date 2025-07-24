import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

enum LayoutType { row, column, stack }

class InAppLayout extends StatelessWidget {
  final Alignment alignment;
  final StackFit fit;
  final Clip clipBehavior;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final VerticalDirection verticalDirection;
  final List<Widget> children;
  final LayoutType layout;

  const InAppLayout({
    super.key,
    this.alignment = Alignment.topLeft,
    this.fit = StackFit.loose,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.clipBehavior = Clip.none,
    this.spacing = 0.0,
    this.layout = LayoutType.column,
    required this.children,
  });

  Alignment get _alignment {
    if (Translation.textDirection == TextDirection.rtl) {
      if (alignment == Alignment.centerLeft) {
        return Alignment.centerRight;
      } else if (alignment == Alignment.centerRight) {
        return Alignment.centerLeft;
      } else if (alignment == Alignment.topLeft) {
        return Alignment.topRight;
      } else if (alignment == Alignment.topRight) {
        return Alignment.topLeft;
      } else if (alignment == Alignment.bottomLeft) {
        return Alignment.bottomRight;
      } else if (alignment == Alignment.bottomRight) {
        return Alignment.bottomLeft;
      }
    }
    return alignment;
  }

  @override
  Widget build(BuildContext context) {
    final direction = Translation.textDirection;
    if (layout == LayoutType.stack) {
      return Stack(
        alignment: _alignment,
        clipBehavior: clipBehavior,
        fit: fit,
        textDirection: direction,
        children: children,
      );
    }
    return Flex(
      textDirection: direction,
      direction: layout == LayoutType.row ? Axis.horizontal : Axis.vertical,
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      spacing: spacing,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

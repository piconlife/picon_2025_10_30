import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';

import '../../app/extensions/text_direction.dart';

class InAppDivider extends StatelessWidget {
  final Color? color;
  final double height;
  final Axis axis;
  final double indent;
  final double endIndent;

  const InAppDivider({
    super.key,
    this.color,
    this.height = 1,
    this.axis = Axis.vertical,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isVertical = axis == Axis.vertical;
    return Container(
      padding:
          EdgeInsets.only(
            left: isVertical ? indent : 0,
            right: isVertical ? endIndent : 0,
            top: isVertical ? 0 : indent,
            bottom: isVertical ? 0 : endIndent,
          ).directional,
      color: color ?? context.dark.t05,
      height: isVertical ? height : double.infinity,
      width: isVertical ? double.infinity : height,
    );
  }
}

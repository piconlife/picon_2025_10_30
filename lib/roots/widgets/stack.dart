import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

class InAppStack extends StatelessWidget {
  final Alignment alignment;
  final StackFit fit;
  final Clip clipBehavior;
  final TextDirection? textDirection;
  final List<Widget> children;

  const InAppStack({
    super.key,
    this.alignment = Alignment.topLeft,
    this.fit = StackFit.loose,
    this.textDirection,
    this.clipBehavior = Clip.none,
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
    return Stack(
      alignment: _alignment,
      clipBehavior: clipBehavior,
      fit: fit,
      textDirection: textDirection,
      children: children,
    );
  }
}

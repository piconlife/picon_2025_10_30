import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

class InAppAlign extends StatelessWidget {
  final Alignment alignment;
  final double? widthFactor;
  final double? heightFactor;
  final Widget? child;

  const InAppAlign({
    super.key,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });

  Alignment get _alignment {
    if (Translation.textDirection == TextDirection.rtl) {
      return Alignment(-alignment.x, alignment.y);
    }
    return alignment;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

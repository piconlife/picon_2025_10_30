import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/text.dart';

class InAppSecondaryButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const InAppSecondaryButton({
    super.key,
    this.height,
    this.borderRadius,
    required this.text,
    this.textStyle = const TextStyle(),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InAppGesture(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.secondary,
          borderRadius: borderRadius ?? BorderRadius.circular(50),
        ),
        padding: height != null
            ? null
            : const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: InAppText(
          text,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            color: textStyle.color ?? context.light,
            fontSize: textStyle.fontSize ?? 22,
            fontWeight: textStyle.fontWeight ?? FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

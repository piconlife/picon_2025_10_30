import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets/icon.dart';
import 'package:in_app_translation/in_app_translation.dart';

class InAppIcon extends StatelessWidget {
  final dynamic data;
  final bool flipByTextDirection;
  final bool visibility;
  final BoxFit? fit;
  final double? size;
  final Color? color;
  final BlendMode tintMode;

  const InAppIcon(
    this.data, {
    super.key,
    this.flipByTextDirection = false,
    this.visibility = true,
    this.fit,
    this.size,
    this.color,
    this.tintMode = BlendMode.srcIn,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Translation.textDirection == TextDirection.rtl;
    Widget child = AndrossyIcon(
      data,
      visibility: visibility,
      fit: fit,
      size: size ?? context.icons.normal,
      color: color ?? context.iconColor.primary,
      tintMode: tintMode,
    );
    if (flipByTextDirection && isRtl) {
      return Transform.flip(flipX: true, child: child);
    } else if (isRtl) {
      return Directionality(textDirection: TextDirection.rtl, child: child);
    }
    return child;
  }
}

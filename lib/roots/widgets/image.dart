import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:in_app_translation/in_app_translation.dart';

class InAppImage extends AndrossyImage {
  final DimenData? dimen;
  final BoxDecoration? decoration;
  final double? widthAsPercentage;
  final double? heightAsPercentage;
  final Axis? transformDirection;
  final bool textDirectionalFlip;

  const InAppImage(
    super.data, {
    this.dimen,
    this.decoration,
    this.heightAsPercentage,
    this.widthAsPercentage,
    this.transformDirection,
    this.textDirectionalFlip = false,
    super.fit,
    super.key,
    super.width,
    super.height,
    super.cacheMode = true,
    super.type = AndrossyImageType.detect,
    super.tint,
    super.tintMode,
    super.networkImageConfig,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = this.dimen ?? context.dimens;
    Widget child = AndrossyImage(
      data,
      width: widthAsPercentage?.dw(dimen) ?? width.dx(dimen),
      height: heightAsPercentage?.dh(dimen) ?? height.dy(dimen),
      cacheMode: cacheMode,
      type: type,
      fit: fit,
      tint: tint,
      tintMode: tintMode,
      networkImageConfig: networkImageConfig,
    );
    final isRtl =
        textDirectionalFlip && Translation.textDirection == TextDirection.rtl;
    if (transformDirection != null || isRtl) {
      child = Transform.flip(
        flipX: isRtl || transformDirection == Axis.horizontal,
        flipY: transformDirection == Axis.vertical,
        child: child,
      );
    }
    if (decoration != null) {
      child = Container(
        clipBehavior: Clip.antiAlias,
        decoration: decoration.applyDimen(dimen),
        child: child,
      );
    }
    if (Translation.textDirection == TextDirection.rtl) {
      return Directionality(
        textDirection: Translation.textDirection,
        child: child,
      );
    }
    return child;
  }
}

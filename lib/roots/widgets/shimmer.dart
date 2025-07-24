import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class InAppShimmer extends StatelessWidget {
  final Color? background;
  final Duration shimmerDuration;
  final Duration fadeDuration;
  final double fadeUpperBound;
  final double fadeLowerBound;
  final double fadeWeight;
  final Color baseColor;
  final Color highlightColor;
  final double loopCount;
  final Widget child;

  const InAppShimmer({
    super.key,
    required this.child,
    this.background,
    this.shimmerDuration = kAndrossyShimmerDuration,
    this.fadeUpperBound = 1.0,
    this.fadeLowerBound = 0.0,
    this.fadeWeight = 50.0,
    this.fadeDuration = kAndrossyShimmerDuration,
    this.baseColor = const Color(0x00E0E0E0),
    this.highlightColor = const Color(0x80F5F5F5),
    this.loopCount = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background ?? Colors.transparent,
      surfaceTintColor: background ?? Colors.transparent,
      child: AndrossyShimmer(
        shimmerDuration: shimmerDuration,
        fadeUpperBound: fadeUpperBound,
        fadeLowerBound: fadeLowerBound,
        fadeWeight: fadeWeight,
        fadeDuration: fadeDuration,
        baseColor: baseColor,
        highlightColor: highlightColor,
        loopCount: loopCount,
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InAppShaderMask extends StatelessWidget {
  final Widget child;
  final double firstStop;
  final double secondStop;
  final double thirdStop;
  final double fourthStop;

  const InAppShaderMask({
    super.key,
    required this.child,
    this.firstStop = 78,
    this.secondStop = 2,
    this.thirdStop = 40,
    this.fourthStop = 20,
  });

  @override
  Widget build(BuildContext context) {
    final root = MediaQuery.of(context);
    return ShaderMask(
      shaderCallback: (Rect rect) {
        double h = root.size.height;
        double top = root.padding.top;
        double bottom = root.padding.bottom;
        double first = top + firstStop;
        double second = first + secondStop;
        double fourth = h - bottom - fourthStop;
        double third = fourth - thirdStop;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.white,
            Colors.transparent,
            Colors.transparent,
            Colors.white,
          ],
          stops: [
            first / h,
            second / h,
            third / h,
            fourth / h,
          ], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }
}

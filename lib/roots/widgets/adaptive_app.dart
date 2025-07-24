import 'package:flutter/material.dart';

class AdaptiveApp extends StatelessWidget {
  final bool enabled;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final double width;
  final double height;
  final Widget child;

  const AdaptiveApp({
    super.key,
    this.enabled = true,
    this.backgroundColor,
    this.decoration,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor ?? Colors.grey,
        body: Center(
          child: Container(
            width: width,
            height: height,
            decoration: decoration,
            child: ClipPath(clipBehavior: Clip.antiAlias, child: child),
          ),
        ),
      ),
    );
  }
}

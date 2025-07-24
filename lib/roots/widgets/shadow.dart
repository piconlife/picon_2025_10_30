import 'package:flutter/material.dart';

class InAppShadow extends StatelessWidget {
  final List<Color>? colors;
  final List<double>? stops;
  final Widget child;

  const InAppShadow({super.key, required this.child, this.colors, this.stops});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors ?? [],
          stops: stops ?? const [0.65, 0.95],
        ),
      ),
      child: child,
    );
  }
}

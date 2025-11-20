import 'package:flutter/material.dart';

class InAppHero extends StatelessWidget {
  final String? tag;
  final CreateRectTween? createRectTween;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;
  final HeroPlaceholderBuilder? placeholderBuilder;
  final bool transitionOnUserGestures;
  final Widget child;

  const InAppHero({
    super.key,
    required this.tag,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.transitionOnUserGestures = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if ((tag ?? '').isEmpty) return child;
    return Hero(
      tag: tag!,
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder,
      placeholderBuilder: placeholderBuilder,
      transitionOnUserGestures: transitionOnUserGestures,
      child: Material(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: child,
      ),
    );
  }
}

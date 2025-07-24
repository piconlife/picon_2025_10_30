import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class InAppCoordinator extends StatelessWidget {
  final ScrollController? controller;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;
  final bool floatHeaderSlivers;
  final Clip clipBehavior;
  final HitTestBehavior hitTestBehavior;
  final String? restorationId;
  final ScrollBehavior? scrollBehavior;

  final Widget? header;
  final Widget? toolbar;
  final Widget child;
  final bool floating;
  final bool pinned;
  final double toolbarHeight;

  const InAppCoordinator({
    super.key,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.floatHeaderSlivers = false,
    this.clipBehavior = Clip.hardEdge,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.restorationId,
    this.scrollBehavior,
    this.header,
    this.toolbar,
    required this.child,
    this.floating = false,
    this.pinned = true,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyCoordinator(
      controller: controller,
      scrollDirection: scrollDirection,
      reverse: reverse,
      physics: physics,
      dragStartBehavior: dragStartBehavior,
      floatHeaderSlivers: floatHeaderSlivers,
      clipBehavior: clipBehavior,
      hitTestBehavior: hitTestBehavior,
      restorationId: restorationId,
      scrollBehavior: scrollBehavior,
      pinned: pinned,
      floating: floating,
      header: header,
      toolbarHeight: toolbarHeight,
      toolbar: toolbar,
      child: child,
    );
  }
}

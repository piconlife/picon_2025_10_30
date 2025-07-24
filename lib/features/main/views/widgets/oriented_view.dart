import 'package:flutter/material.dart';

import '../../../../roots/utils/utils.dart';

class OrientedView extends StatefulWidget {
  final bool landscape;
  final ValueWidgetBuilder<bool> builder;
  final Widget? child;

  const OrientedView({
    super.key,
    this.landscape = true,
    required this.builder,
    this.child,
  });

  @override
  State<OrientedView> createState() => _OrientedViewState();
}

class _OrientedViewState extends State<OrientedView> {
  bool fullscreen = false;

  void toggle() {
    try {
      Utils.setOrientation(
        fullscreen ? Orientation.portrait : Orientation.landscape,
      );
      setState(() => fullscreen = !fullscreen);
    } catch (_) {}
  }

  Future<bool> _willPop() async {
    if (fullscreen) {
      toggle();
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    if (fullscreen) toggle();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: widget.builder(context, fullscreen, widget.child),
    );
  }
}

import 'package:flutter/material.dart';

class MultiListenableBuilder extends StatefulWidget {
  final List<Listenable> listenables;
  final Widget? child;
  final Widget Function(BuildContext context, Widget? child) builder;

  const MultiListenableBuilder({
    super.key,
    required this.listenables,
    required this.builder,
    this.child,
  });

  @override
  State<MultiListenableBuilder> createState() => _MultiListenableBuilderState();
}

class _MultiListenableBuilderState extends State<MultiListenableBuilder> {
  void listener() {
    setState(() {});
  }

  @override
  void initState() {
    for (var listenable in widget.listenables) {
      listenable.addListener(listener);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MultiListenableBuilder oldWidget) {
    if (oldWidget.listenables != widget.listenables) {
      for (var listenable in oldWidget.listenables) {
        listenable.removeListener(listener);
      }
      for (var listenable in widget.listenables) {
        listenable.addListener(listener);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    for (var listenable in widget.listenables) {
      listenable.removeListener(listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }
}

import 'package:flutter/material.dart';

import 'will_pop_scope.dart';

class CoverManager extends ChangeNotifier {
  bool status;

  CoverManager._(this.status);

  final Map<String, bool> _skippedPages = {};

  bool get isActive => status;

  bool get isInactive => !status;

  bool isSkipped(String name) => _skippedPages[name] ?? false;

  void changeStatus(bool value) {
    status = value;
    notifyListeners();
  }

  void setSkipped(String name) {
    _skippedPages[name] = true;
    notifyListeners();
  }

  static final Map<String, CoverManager> _proxies = {};

  factory CoverManager.of(String name, [bool status = false]) {
    return _proxies[name] ??= CoverManager._(status);
  }

  static void kill() {
    try {
      _proxies.forEach((a, b) {
        try {
          b.dispose();
          _proxies.remove(a);
        } catch (_) {}
      });
      _proxies.clear();
    } catch (_) {}
  }
}

class InAppCover extends StatefulWidget {
  final String? tag;
  final String name;
  final bool enabled;
  final bool isSkipMode;
  final bool isBackMode;
  final bool status;
  final Widget cover;
  final Widget child;
  final ValueGetter<bool>? isCloseMode;
  final VoidCallback? onClose;

  const InAppCover({
    super.key,
    this.tag,
    required this.name,
    this.enabled = true,
    this.isSkipMode = false,
    this.isBackMode = true,
    this.status = false,
    required this.cover,
    required this.child,
    this.isCloseMode,
    this.onClose,
  });

  @override
  State<InAppCover> createState() => _InAppCoverState();
}

class _InAppCoverState extends State<InAppCover> {
  late CoverManager manager = CoverManager.of(widget.name, widget.status);

  String get tag => widget.tag ?? widget.child.toString();

  bool get isSkipped {
    if (!widget.isSkipMode) return false;
    return manager.isSkipped(tag);
  }

  bool get isActive => isSkipped || manager.isActive;

  void skip() {
    manager.setSkipped(tag);
    if (widget.isCloseMode?.call() ?? Navigator.canPop(context)) {
      if (widget.onClose == null) {
        Navigator.pop(context);
      } else {
        widget.onClose!();
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return InAppWillPopScope(
      onWillPop: () async => widget.isBackMode,
      child: ListenableBuilder(
        listenable: manager,
        child: widget.child,
        builder: (context, child) {
          return isActive ? child ?? widget.child : widget.cover;
        },
      ),
    );
  }
}

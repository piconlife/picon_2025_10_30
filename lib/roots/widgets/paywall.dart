import 'package:flutter/material.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../features/paywall/views/pages/paywall.dart';
import '../notifiers/paywall.dart';

class InAppPaywall extends StatefulWidget {
  final String name;
  final bool enabled;
  final bool isSkipMode;
  final bool isBackMode;
  final Widget child;

  const InAppPaywall({
    super.key,
    required this.name,
    this.enabled = true,
    this.isSkipMode = false,
    this.isBackMode = true,
    required this.child,
  });

  @override
  State<InAppPaywall> createState() => _InAppPaywallState();
}

class _InAppPaywallState extends State<InAppPaywall> {
  bool get isSkipped {
    if (!widget.isSkipMode) return false;
    return PaywallNotifier.isSkipped(widget.name);
  }

  bool get isUnlocked {
    return isSkipped || PaywallNotifier.isPremium;
  }

  void skip() {
    PaywallNotifier.setSkipped(widget.name);
    if (Navigator.canPop(context)) {
      context.close();
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return ListenableBuilder(
      listenable: PaywallNotifier.i,
      child: widget.child,
      builder: (context, child) {
        return _build(context, isUnlocked, child ?? widget.child);
      },
    );
  }

  Widget _build(BuildContext context, bool premium, Widget child) {
    if (premium) return child;
    return PaywallPage(
      isBackMode: widget.isBackMode,
      onSkipped: widget.isSkipMode ? skip : null,
    );
  }
}

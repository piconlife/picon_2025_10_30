import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InAppSystemOverlay extends StatefulWidget {
  final bool? dark;
  final SystemUiMode systemUiMode;
  final List<SystemUiOverlay> overlays;
  final bool restore;
  final List<DeviceOrientation> orientations;

  final Color? switcherColor;
  final String? switcherLabel;

  final Brightness? statusBarBrightness;
  final Color? statusBarColor;
  final bool? systemStatusBarContrastEnforced;
  final Brightness? statusBarIconBrightness;
  final Color? systemNavigationBarColor;
  final bool? systemNavigationBarContrastEnforced;
  final Color? systemNavigationBarDividerColor;
  final Brightness? systemNavigationBarIconBrightness;
  final SystemUiChangeCallback? systemUiChangeCallback;
  final Widget child;

  const InAppSystemOverlay({
    super.key,
    this.dark,
    this.systemUiMode = SystemUiMode.edgeToEdge,
    this.overlays = const [],
    this.restore = false,
    this.statusBarBrightness,
    this.statusBarColor,
    this.systemStatusBarContrastEnforced,
    this.statusBarIconBrightness,
    this.systemNavigationBarColor,
    this.systemNavigationBarContrastEnforced,
    this.systemNavigationBarDividerColor,
    this.systemNavigationBarIconBrightness,
    this.systemUiChangeCallback,
    this.orientations = const [],
    this.switcherColor,
    this.switcherLabel,
    required this.child,
  });

  @override
  State<InAppSystemOverlay> createState() => _InAppSystemOverlayState();
}

class _InAppSystemOverlayState extends State<InAppSystemOverlay> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final brightness =
        widget.dark != null
            ? (widget.dark! ? Brightness.dark : Brightness.light)
            : null;

    final iconBrightness =
        widget.dark != null
            ? (widget.dark! ? Brightness.light : Brightness.dark)
            : null;

    final color =
        widget.dark != null
            ? (widget.dark! ? Colors.black : Colors.white).withValues(
              alpha: 0.002,
            )
            : null;

    final t = Theme.of(context);
    final d = t.brightness == Brightness.dark;
    final i = t.appBarTheme.systemOverlayStyle;
    final defaultColor = (d ? Colors.black : Colors.white).withValues(
      alpha: 0.002,
    );
    final defaultBrightness = d ? Brightness.dark : Brightness.light;
    final defaultIconBrightness = d ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness:
            widget.statusBarBrightness ??
            brightness ??
            i?.statusBarBrightness ??
            defaultBrightness,
        statusBarColor:
            widget.statusBarColor ?? color ?? i?.statusBarColor ?? defaultColor,
        systemStatusBarContrastEnforced:
            widget.systemStatusBarContrastEnforced ??
            i?.systemStatusBarContrastEnforced,
        statusBarIconBrightness:
            widget.statusBarIconBrightness ??
            iconBrightness ??
            i?.statusBarIconBrightness ??
            defaultIconBrightness,
        systemNavigationBarColor:
            widget.systemNavigationBarColor ??
            color ??
            i?.systemNavigationBarColor ??
            defaultColor,
        systemNavigationBarContrastEnforced:
            widget.systemNavigationBarContrastEnforced ??
            i?.systemNavigationBarContrastEnforced,
        systemNavigationBarDividerColor:
            widget.systemNavigationBarDividerColor ??
            color ??
            i?.systemNavigationBarDividerColor ??
            defaultColor,
        systemNavigationBarIconBrightness:
            widget.systemNavigationBarIconBrightness ??
            iconBrightness ??
            i?.systemNavigationBarIconBrightness ??
            defaultIconBrightness,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(
      widget.overlays.isNotEmpty ? SystemUiMode.manual : widget.systemUiMode,
      overlays: widget.overlays,
    );

    if (widget.orientations.isNotEmpty) {
      SystemChrome.setPreferredOrientations(widget.orientations);
    }

    if (widget.restore) {
      SystemChrome.restoreSystemUIOverlays();
    }

    if (widget.switcherColor != null || widget.switcherLabel != null) {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
          primaryColor: widget.switcherColor?.value,
          label: widget.switcherLabel,
        ),
      );
    }

    if (widget.systemUiChangeCallback != null) {
      SystemChrome.setSystemUIChangeCallback(widget.systemUiChangeCallback);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

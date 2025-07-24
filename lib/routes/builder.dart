import 'package:flutter/material.dart';

typedef RouteBuilder = Widget Function(BuildContext context, Object? data);

extension AppRouteExtenstion on Object? {
  T call<T>(String key, T secondary) {
    var root = this;
    if (root is Map<String, dynamic>) {
      var data = root[key];
      if (data is T) {
        return data;
      } else {
        return secondary;
      }
    } else {
      if (root is T) {
        return root;
      } else {
        return secondary;
      }
    }
  }

  T? get<T>(String key, [T? secondary]) => call(key, secondary);
}

abstract class InAppRouteGenerator {
  final String? home;

  const InAppRouteGenerator({this.home});

  TextDirection get textDirection;

  InAppRouteConfig get config => const InAppRouteConfig();

  Widget defaultPage(BuildContext context, Object? data);

  Widget errorPage(BuildContext context, Object? data) => const ErrorScreen();

  Map<String, RouteBuilder> pages();

  Widget pageBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    TransitionType? animationType,
    Widget child,
  ) {
    return child;
  }

  Widget transition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    TransitionType? animationType,
    Widget child,
  ) {
    return _Transitions(
      textDirection,
      CurvedAnimation(
        parent: animation,
        curve: config.transitionCurve ?? Curves.decelerate,
      ),
      secondaryAnimation,
    ).select(child, animationType ?? TransitionType.slideRight);
  }

  Route<T> defaultRoute<T>(
    RouteSettings settings,
    InAppRouteConfig config,
    WidgetBuilder builder,
  ) {
    return route(settings, config, builder);
  }

  Route<T> route<T>(
    RouteSettings settings,
    InAppRouteConfig config,
    WidgetBuilder builder,
  ) {
    final defaultTransition = const Duration(milliseconds: 300);
    return PageRouteBuilder(
      allowSnapshotting: config.allowSnapshotting ?? true,
      barrierColor: config.barrierColor,
      barrierDismissible: config.barrierDismissible ?? false,
      barrierLabel: config.barrierLabel,
      fullscreenDialog: config.fullscreenDialog ?? false,
      opaque: config.opaque ?? true,
      maintainState: config.maintainState ?? true,
      transitionDuration: config.transitionDuration ?? defaultTransition,
      reverseTransitionDuration:
          config.reverseTransitionDuration ??
          config.transitionDuration ??
          defaultTransition,
      pageBuilder: (c, p, s) {
        return pageBuilder(c, p, s, config.transitionType, builder(c));
      },
      settings: settings,
      transitionsBuilder: (c, p, s, child) {
        return transition(c, p, s, config.transitionType, child);
      },
    );
  }

  Route<T> generate<T>(RouteSettings settings) {
    final data = settings.arguments;
    final pages = this.pages();
    var mConfig = config.adjust(data("__app_route_config__", config));
    if (pages.isEmpty) {
      return route(settings, mConfig, (c) => defaultPage(c, data));
    }
    final name = settings.name;
    final page = pages[name];
    if (page == null) {
      return route(settings, mConfig, (c) => errorPage(c, data));
    }
    if (name == home) {
      return defaultRoute(settings, mConfig, (c) => page(c, data));
    }
    return route(settings, mConfig, (c) => page(c, data));
  }
}

class InAppRouteConfig {
  final bool? allowSnapshotting;
  final Curve? transitionCurve;
  final TransitionType? transitionType;
  final Duration? transitionDuration;
  final Duration? reverseTransitionDuration;
  final Color? barrierColor;
  final bool? barrierDismissible;
  final String? barrierLabel;
  final bool? fullscreenDialog;
  final bool? maintainState;
  final bool? opaque;
  final bool? cupertino;

  const InAppRouteConfig({
    this.allowSnapshotting,
    this.transitionCurve,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.transitionType,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.fullscreenDialog,
    this.maintainState,
    this.opaque,
    this.cupertino,
  });

  InAppRouteConfig adjust(InAppRouteConfig config) {
    return InAppRouteConfig(
      allowSnapshotting: config.allowSnapshotting ?? allowSnapshotting,
      transitionCurve: config.transitionCurve ?? transitionCurve,
      transitionDuration: config.transitionDuration ?? transitionDuration,
      reverseTransitionDuration:
          config.reverseTransitionDuration ?? reverseTransitionDuration,
      transitionType: config.transitionType ?? transitionType,
      barrierColor: config.barrierColor ?? barrierColor,
      barrierDismissible: config.barrierDismissible ?? barrierDismissible,
      barrierLabel: config.barrierLabel ?? barrierLabel,
      fullscreenDialog: config.fullscreenDialog ?? fullscreenDialog,
      maintainState: config.maintainState ?? maintainState,
      opaque: config.opaque ?? opaque,
      cupertino: config.cupertino ?? cupertino,
    );
  }
}

enum Flag { none, clear, replacement }

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: SafeArea(
        child: Center(
          child: Text(
            "No screen found!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

enum TransitionType {
  none,
  card,
  diagonal,
  fadeIn,
  inAndOut,
  shrink,
  rotation,
  split,
  slideLeft,
  slideRight,
  slideDown,
  slideUp,
  slideLeftWithFade,
  slideRightWithFade,
  slideDownWithFade,
  slideUpWithFade,
  swipeLeft,
  swipeRight,
  windmill,
  zoom,
  zoomWithFade,
}

class _Transitions {
  final TextDirection textDirection;
  final Animation<double> primary;
  final Animation<double> secondary;

  const _Transitions(
    this.textDirection,
    this.primary, [
    Animation<double>? secondary,
  ]) : secondary = secondary ?? primary;

  bool get isRtl => textDirection == TextDirection.rtl;

  Widget select(Widget view, TransitionType type) {
    switch (type) {
      case TransitionType.none:
        return _slideLeftToRight(view);
      case TransitionType.card:
        return _slideLeftToRight(view);
      case TransitionType.diagonal:
        return _slideLeftToRight(view);
      case TransitionType.fadeIn:
        return _fadeIn(view);
      case TransitionType.inAndOut:
        return _slideLeftToRight(view);
      case TransitionType.rotation:
        return _rotation(view);
      case TransitionType.shrink:
        return _slideLeftToRight(view);
      case TransitionType.split:
        return _slideLeftToRight(view);
      case TransitionType.slideLeft:
        return _slideLeftToRight(view);
      case TransitionType.slideRight:
        return _slideRightToLeft(view);
      case TransitionType.slideDown:
        return _slideDown(view);
      case TransitionType.slideUp:
        return _slideUp(view);
      case TransitionType.slideLeftWithFade:
        return _slideLeftToRightWithFade(view);
      case TransitionType.slideRightWithFade:
        return _slideRightToLeftWithFade(view);
      case TransitionType.slideDownWithFade:
        return _slideDownWithFade(view);
      case TransitionType.slideUpWithFade:
        return _slideUpWithFade(view);
      case TransitionType.swipeLeft:
        return _slideRightToLeft(view);
      case TransitionType.swipeRight:
        return _slideRightToLeft(view);
      case TransitionType.windmill:
        return _slideRightToLeft(view);
      case TransitionType.zoom:
        return _zoom(view);
      case TransitionType.zoomWithFade:
        return _zoomWithFade(view);
    }
  }

  Widget _slideLeftToRight(Widget view) {
    return isRtl ? _slideRight(view) : _slideLeft(view);
  }

  Widget _slideRightToLeft(Widget view) {
    return isRtl ? _slideLeft(view) : _slideRight(view);
  }

  Widget _slideLeftToRightWithFade(Widget view) {
    return isRtl ? _slideRightWithFade(view) : _slideLeftWithFade(view);
  }

  Widget _slideRightToLeftWithFade(Widget view) {
    return isRtl ? _slideLeftWithFade(view) : _slideRightWithFade(view);
  }

  Widget _fadeIn(Widget view) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(primary),
      child: view,
    );
  }

  Widget _slideUp(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget _slideDown(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget _slideLeft(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget _slideRight(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: view,
    );
  }

  Widget _slideUpWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }

  Widget _slideDownWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }

  Widget _slideLeftWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }

  Widget _slideRightWithFade(Widget view) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }

  Widget _rotation(Widget view) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.5, end: 1.0).animate(primary),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(primary),
        child: view,
      ),
    );
  }

  Widget _zoom(Widget view) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(primary),
      child: view,
    );
  }

  Widget _zoomWithFade(Widget view) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(primary),
      child: Opacity(opacity: primary.value, child: view),
    );
  }
}

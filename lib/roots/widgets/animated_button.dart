import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef AndrossyAnimationBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Widget child,
    );

class AndrossyAnimation extends StatefulWidget {
  final List<Animations> animations;
  final ValueChanged<AndrossyAnimationState>? onReady;
  final ValueChanged<bool>? onAnimating;
  final Widget child;

  const AndrossyAnimation({
    super.key,
    this.animations = const [],
    this.onReady,
    this.onAnimating,
    required this.child,
  });

  @override
  State<AndrossyAnimation> createState() => AndrossyAnimationState();
}

class AndrossyAnimationState extends State<AndrossyAnimation>
    with TickerProviderStateMixin {
  final Map<Animations, AnimationController> _animations = {};

  bool get isInitialized => _animations.isNotEmpty;

  void _init() {
    for (final e in widget.animations) {
      if (!e.isActivated) continue;
      _animations[e] = AnimationController(
        vsync: this,
        animationBehavior: e.behavior,
        debugLabel: e.debugLabel,
        duration: e.duration,
        reverseDuration: e.reverseDuration,
        value: e.value,
        upperBound: e.upperBound,
        lowerBound: e.lowerBound,
      );
    }
    widget.onReady?.call(this);
  }

  void _ready() {
    if (widget.onReady == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isInitialized) return;
      widget.onReady!(this);
    });
  }

  void _cancel() {
    if (!isInitialized) return;
    _animations.forEach((a, b) {
      b.dispose();
    });
    _animations.clear();
    widget.onReady?.call(this);
  }

  @override
  void initState() {
    _init();
    _ready();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AndrossyAnimation oldWidget) {
    if (widget.animations != oldWidget.animations) {
      _cancel();
      _init();
    }
    if (widget.onReady != oldWidget.onReady) {
      _ready();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }

  void animate() async {
    if (!isInitialized) return;
    widget.onAnimating?.call(true);
    int count = 0;
    _animations.forEach((a, b) {
      b.reverse().whenComplete(b.forward).whenComplete(() {
        count++;
        if (count != _animations.length) return;
        count = 0;
        widget.onAnimating?.call(false);
      });
    });
  }

  void animateEnd() {
    if (!isInitialized) return;
    int count = 0;
    _animations.forEach((a, b) {
      b.forward().whenComplete(() {
        count++;
        if (count != _animations.length) return;
        count = 0;
        widget.onAnimating?.call(false);
      });
    });
  }

  void animateStart() {
    if (!isInitialized) return;
    int count = 0;
    _animations.forEach((a, b) {
      b.reverse().whenComplete(() {
        count++;
        if (count != _animations.length) return;
        count = 0;
        widget.onAnimating?.call(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    _animations.forEach((a, b) {
      child = a.build(context: context, parent: b, child: child);
    });
    return child;
  }
}

class AnimatedButton extends StatefulWidget {
  final List<Animations> animations;
  final bool excludeFromSemantics;
  final Set<PointerDeviceKind>? supportedDevices;
  final HitTestBehavior? behavior;
  final Duration longPressStartTime;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onAnimating;
  final ValueChanged<bool>? onHover;
  final bool enableHoverAnimation;
  final Widget child;

  const AnimatedButton({
    super.key,
    required this.animations,
    this.supportedDevices,
    this.excludeFromSemantics = false,
    this.behavior,
    this.longPressStartTime = const Duration(milliseconds: 200),
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onAnimating,
    this.onHover,
    this.enableHoverAnimation = true,
    required this.child,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  final _key = GlobalKey<AndrossyAnimationState>();
  bool _isHovering = false;

  AndrossyAnimationState? get state => _key.currentState;

  void _onTap() {
    state?.animate();
    widget.onTap?.call();
  }

  void _onDoubleTap() {
    state?.animate();
    widget.onDoubleTap?.call();
  }

  void _onLongPressStart([_]) {
    state?.animateStart();
  }

  void _onLongPressEnd([_]) {
    state?.animateEnd();
    widget.onLongPress?.call();
  }

  void _onHoverEnter(PointerEnterEvent event) {
    if (!_isHovering) {
      setState(() => _isHovering = true);
      widget.onHover?.call(true);
      if (widget.enableHoverAnimation) {
        state?.animateStart();
      }
    }
  }

  void _onHoverExit(PointerExitEvent event) {
    if (_isHovering) {
      setState(() => _isHovering = false);
      widget.onHover?.call(false);
      if (widget.enableHoverAnimation) {
        state?.animateEnd();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<Type, GestureRecognizerFactory> gestures = {};
    final gestureSettings = MediaQuery.maybeGestureSettingsOf(context);

    if (widget.onTap != null) {
      gestures[TapGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
            () => TapGestureRecognizer(
              debugOwner: this,
              supportedDevices: widget.supportedDevices,
            ),
            (instance) {
              instance
                ..onTap = _onTap
                ..gestureSettings = gestureSettings
                ..supportedDevices = widget.supportedDevices;
            },
          );
    }

    if (widget.onDoubleTap != null) {
      gestures[DoubleTapGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
            () {
              return DoubleTapGestureRecognizer(
                debugOwner: this,
                supportedDevices: widget.supportedDevices,
              );
            },
            (instance) {
              instance
                ..onDoubleTap = _onDoubleTap
                ..gestureSettings = gestureSettings
                ..supportedDevices = widget.supportedDevices;
            },
          );
    }

    if (widget.onLongPress != null) {
      gestures[LongPressGestureRecognizer] =
          GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(
              debugOwner: this,
              duration: widget.longPressStartTime,
              supportedDevices: widget.supportedDevices,
            ),
            (LongPressGestureRecognizer instance) {
              instance
                ..onLongPressStart = _onLongPressStart
                ..onLongPressEnd = _onLongPressEnd
                ..gestureSettings = gestureSettings
                ..supportedDevices = widget.supportedDevices;
            },
          );
    }

    Widget child = RawGestureDetector(
      gestures: gestures,
      behavior: widget.behavior,
      excludeFromSemantics: widget.excludeFromSemantics,
      child: AndrossyAnimation(
        key: _key,
        animations: widget.animations,
        onAnimating: widget.onAnimating,
        child: widget.child,
      ),
    );

    if (widget.onHover != null && kIsWeb) {
      child = MouseRegion(
        onEnter: _onHoverEnter,
        onExit: _onHoverExit,
        cursor: SystemMouseCursors.click,
        child: child,
      );
    }
    return child;
  }
}

class Animations {
  final AnimationBehavior behavior;
  final Curve curve;
  final Curve? reverseCurve;
  final String? debugLabel;
  final Duration duration;
  final Duration? reverseDuration;
  final _Effects _effect;
  final double value;
  final double lowerBound;
  final double upperBound;
  final bool repeat;
  final Object? begin;
  final Object? end;
  final AndrossyAnimationBuilder? builder;

  bool get isActivated =>
      _effect != _Effects.none &&
      duration != Duration.zero &&
      ((lowerBound != 1 && upperBound > 0) ||
          (begin != null && end != null) ||
          builder != null);

  const Animations.none() : this();

  const Animations({
    this.builder,
    this.behavior = AnimationBehavior.normal,
    this.debugLabel,
    this.duration = const Duration(milliseconds: 130),
    this.curve = Curves.linear,
    this.reverseCurve,
    this.reverseDuration,
    this.value = 1.0,
    this.upperBound = 1.0,
    this.lowerBound = 0.0,
    this.repeat = false,
    this.begin,
    this.end,
  }) : _effect = builder != null ? _Effects.custom : _Effects.none;

  const Animations.fade({
    this.builder,
    this.behavior = AnimationBehavior.normal,
    this.debugLabel,
    this.duration = const Duration(milliseconds: 130),
    this.curve = Curves.linear,
    this.reverseCurve,
    this.reverseDuration,
    this.value = 1.0,
    this.upperBound = 1.0,
    this.lowerBound = 0.0,
    this.repeat = false,
    double this.begin = 0.75,
    double this.end = 1.0,
  }) : _effect = _Effects.fade;

  const Animations.rotate({
    this.builder,
    this.behavior = AnimationBehavior.normal,
    this.debugLabel,
    this.duration = const Duration(milliseconds: 130),
    this.curve = Curves.linear,
    this.reverseCurve,
    this.reverseDuration,
    this.value = 1.0,
    this.upperBound = 1.0,
    this.lowerBound = 0.0,
    this.repeat = false,
    double this.begin = 1.0,
    double this.end = 0.95,
  }) : _effect = _Effects.rotate;

  const Animations.scale({
    this.builder,
    this.behavior = AnimationBehavior.normal,
    this.debugLabel,
    this.duration = const Duration(milliseconds: 130),
    this.curve = Curves.linear,
    this.reverseCurve,
    this.reverseDuration,
    this.value = 1.0,
    this.upperBound = 1.0,
    this.lowerBound = 0.0,
    this.repeat = false,
    double this.begin = 0.95,
    double this.end = 1.0,
  }) : _effect = _Effects.scale;

  const Animations.slide({
    this.builder,
    this.behavior = AnimationBehavior.normal,
    this.debugLabel,
    this.duration = const Duration(milliseconds: 130),
    this.curve = Curves.linear,
    this.reverseCurve,
    this.reverseDuration,
    this.value = 1.0,
    this.upperBound = 1.0,
    this.lowerBound = 0.0,
    this.repeat = false,
    Offset this.begin = const Offset(0, -0.1),
    Offset this.end = const Offset(0, 0),
  }) : _effect = _Effects.slide;

  Tween<double> get tween {
    final begin = this.begin;
    if (begin is! num) return Tween(begin: 0.0, end: 0.0);
    final end = this.end;
    if (end is! num) return Tween(begin: 0.0, end: 0.0);
    return Tween<double>(begin: begin.toDouble(), end: end.toDouble());
  }

  Tween<Offset> get offset {
    final begin = this.begin;
    if (begin is! Offset) return Tween(begin: Offset.zero, end: Offset.zero);
    final end = this.end;
    if (end is! Offset) return Tween(begin: Offset.zero, end: Offset.zero);
    return Tween<Offset>(begin: begin, end: end);
  }

  Widget build({
    required BuildContext context,
    required Animation<double> parent,
    required Widget child,
  }) {
    final anim = CurvedAnimation(
      parent: parent,
      curve: curve,
      reverseCurve: reverseCurve,
    );
    if (_effect == _Effects.slide) {
      return SlideTransition(position: offset.animate(anim), child: child);
    }
    final tween = this.tween.animate(anim);
    switch (_effect) {
      case _Effects.fade:
        return FadeTransition(opacity: tween, child: child);
      case _Effects.rotate:
        return RotationTransition(turns: tween, child: child);
      case _Effects.scale:
        return ScaleTransition(scale: tween, child: child);
      case _Effects.custom:
        if (builder == null) return child;
        return builder!(context, anim, child);
      case _Effects.slide:
      case _Effects.none:
        return child;
    }
  }

  @override
  int get hashCode =>
      _effect.hashCode ^
      duration.hashCode ^
      lowerBound.hashCode ^
      upperBound.hashCode ^
      repeat.hashCode ^
      begin.hashCode ^
      end.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

enum _Effects { fade, rotate, scale, slide, custom, none }

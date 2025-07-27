part of 'view.dart';

enum ViewClickEffects {
  none,
  bounce,
  custom;

  bool get isNone => this == none;

  bool get isBounce => this == bounce;

  bool get isCustom => this == custom;
}

typedef OnClickEffectBuilder = Widget Function(
  BuildContext context,
  double value,
  Widget child,
);

class ViewClickEffect {
  final AnimationBehavior behavior;
  final Curve curve;
  final Curve? reverseCurve;
  final Duration duration;
  final Duration? reverseDuration;
  final ViewClickEffects effect;
  final double value;
  final double lowerBound;
  final double upperBound;
  final OnClickEffectBuilder? builder;

  const ViewClickEffect._({
    this.behavior = AnimationBehavior.normal,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
    this.effect = ViewClickEffects.none,
    this.value = 1,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    this.builder,
  });

  const ViewClickEffect({
    required OnClickEffectBuilder builder,
    AnimationBehavior behavior = AnimationBehavior.normal,
    Curve curve = Curves.linear,
    Curve? reverseCurve,
    Duration duration = const Duration(milliseconds: 200),
    Duration? reverseDuration,
    double value = 1.0,
    double upperBound = 1.0,
    double lowerBound = 0.5,
  }) : this._(
          effect: ViewClickEffects.custom,
          behavior: behavior,
          curve: curve,
          reverseCurve: reverseCurve,
          duration: duration,
          reverseDuration: reverseDuration,
          value: value,
          upperBound: upperBound,
          lowerBound: lowerBound,
          builder: builder,
        );

  const ViewClickEffect.none() : this._();

  const ViewClickEffect.bounce({
    AnimationBehavior behavior = AnimationBehavior.normal,
    Curve curve = Curves.linear,
    Curve? reverseCurve,
    Duration duration = const Duration(milliseconds: 200),
    Duration? reverseDuration,
    double value = 1.0,
    double upperBound = 1.0,
    double lowerBound = 0.95,
  }) : this._(
          effect: ViewClickEffects.bounce,
          behavior: behavior,
          curve: curve,
          reverseCurve: reverseCurve,
          duration: duration,
          reverseDuration: reverseDuration,
          value: value,
          upperBound: upperBound,
          lowerBound: lowerBound,
        );
}

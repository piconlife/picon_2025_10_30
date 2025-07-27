part of 'view.dart';

class ArrowConfig {
  final Widget? arrow;
  final dynamic icon;
  final Color? color;
  final double? size;

  const ArrowConfig({
    this.arrow,
    this.icon,
    this.color,
    this.size,
  });

  ArrowConfig copy({
    Widget? arrow,
    dynamic icon,
    double? size,
    Color? color,
  }) {
    return ArrowConfig(
      arrow: arrow ?? this.arrow,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}

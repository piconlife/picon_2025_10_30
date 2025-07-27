part of 'view.dart';

class SwitchConfig {
  final double size;

  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final Color? activeThumbStrokeColor;
  final Color? inactiveThumbStrokeColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeTrackStrokeColor;
  final Color? inactiveTrackStrokeColor;

  final dynamic activeThumbIcon;
  final dynamic inactiveThumbIcon;
  final Color? activeThumbIconTint;
  final Color? inactiveThumbIconTint;

  final double? activeThumbSpacing;
  final double? inactiveThumbSpacing;
  final double? activeThumbStrokeSize;
  final double? inactiveThumbStrokeSize;

  final double? thumbIconSpacing;
  final int thumbWalkingTime;
  final double? trackBorderRadius;
  final double? trackStrokeSize;
  final double trackRatio;

  const SwitchConfig({
    this.size = 30,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.activeThumbStrokeColor,
    this.inactiveThumbStrokeColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeTrackStrokeColor,
    this.inactiveTrackStrokeColor,
    this.activeThumbIcon,
    this.inactiveThumbIcon,
    this.activeThumbIconTint,
    this.inactiveThumbIconTint,
    this.activeThumbSpacing,
    this.inactiveThumbSpacing,
    this.activeThumbStrokeSize,
    this.inactiveThumbStrokeSize,
    this.thumbIconSpacing,
    this.thumbWalkingTime = 200,
    this.trackBorderRadius,
    this.trackStrokeSize,
    this.trackRatio = 1.65,
  });

  SwitchConfig copy({
    bool? enabled,
    bool? value,
    double? size,
    Color? activeThumbColor,
    Color? inactiveThumbColor,
    Color? activeThumbStrokeColor,
    Color? inactiveThumbStrokeColor,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? activeTrackStrokeColor,
    Color? inactiveTrackStrokeColor,
    dynamic activeThumbIcon,
    dynamic inactiveThumbIcon,
    Color? activeThumbIconTint,
    Color? inactiveThumbIconTint,
    double? activeThumbSpacing,
    double? inactiveThumbSpacing,
    double? activeThumbStrokeSize,
    double? inactiveThumbStrokeSize,
    double? thumbIconSpacing,
    int? thumbWalkingTime,
    double? trackBorderRadius,
    double? trackStrokeSize,
    double? trackRatio,
  }) {
    return SwitchConfig(
      activeThumbColor: activeThumbColor ?? this.activeThumbColor,
      activeThumbIcon: activeThumbIcon ?? this.activeThumbIcon,
      activeThumbIconTint: activeThumbIconTint ?? this.activeThumbIconTint,
      activeThumbStrokeColor:
          activeThumbStrokeColor ?? this.activeThumbStrokeColor,
      activeThumbStrokeSize:
          activeThumbStrokeSize ?? this.activeThumbStrokeSize,
      activeThumbSpacing: activeThumbSpacing ?? this.activeThumbSpacing,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      activeTrackStrokeColor:
          activeTrackStrokeColor ?? this.activeTrackStrokeColor,
      inactiveThumbColor: inactiveThumbColor ?? this.inactiveThumbColor,
      inactiveThumbIcon: inactiveThumbIcon ?? this.inactiveThumbIcon,
      inactiveThumbIconTint:
          inactiveThumbIconTint ?? this.inactiveThumbIconTint,
      inactiveThumbStrokeColor:
          inactiveThumbStrokeColor ?? this.inactiveThumbStrokeColor,
      inactiveThumbStrokeSize:
          inactiveThumbStrokeSize ?? this.inactiveThumbStrokeSize,
      inactiveThumbSpacing: inactiveThumbSpacing ?? this.inactiveThumbSpacing,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      inactiveTrackStrokeColor:
          inactiveTrackStrokeColor ?? this.inactiveTrackStrokeColor,
      size: size ?? this.size,
      thumbIconSpacing: thumbIconSpacing ?? this.thumbIconSpacing,
      thumbWalkingTime: thumbWalkingTime ?? this.thumbWalkingTime,
      trackBorderRadius: trackBorderRadius ?? this.trackBorderRadius,
      trackRatio: trackRatio ?? this.trackRatio,
      trackStrokeSize: trackStrokeSize ?? this.trackStrokeSize,
    );
  }
}

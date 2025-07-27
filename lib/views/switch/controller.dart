part of 'view.dart';

class SwitchViewController extends ViewController {
  double size = 30;

  void setSize(double value) {
    onNotifyWithCallback(() => size = value);
  }

  Color? activeThumbColor;

  void setActiveThumbColor(Color? value) {
    onNotifyWithCallback(() => activeThumbColor = value);
  }

  Color? inactiveThumbColor;

  void setInactiveThumbColor(Color? value) {
    onNotifyWithCallback(() => inactiveThumbColor = value);
  }

  Color? activeThumbStrokeColor;

  void setActiveThumbStrokeColor(Color? value) {
    onNotifyWithCallback(() => activeThumbStrokeColor = value);
  }

  Color? inactiveThumbStrokeColor;

  void setInactiveThumbStrokeColor(Color? value) {
    onNotifyWithCallback(() => inactiveThumbStrokeColor = value);
  }

  /// TRACT COMPONENTS
  Color? activeTrackColor;

  void setActiveTrackColor(Color? value) {
    onNotifyWithCallback(() => activeTrackColor = value);
  }

  Color? inactiveTrackColor;

  void setInactiveTrackColor(Color? value) {
    onNotifyWithCallback(() => inactiveTrackColor = value);
  }

  Color? activeTrackStrokeColor;

  void setActiveTrackStrokeColor(Color? value) {
    onNotifyWithCallback(() => activeTrackStrokeColor = value);
  }

  Color? inactiveTrackStrokeColor;

  void setInactiveTrackStrokeColor(Color? value) {
    onNotifyWithCallback(() => inactiveTrackStrokeColor = value);
  }

  /// THUMB COMPONENTS
  dynamic activeThumbIcon;

  void setActiveThumbIcon(dynamic value) {
    onNotifyWithCallback(() => activeThumbIcon = value);
  }

  dynamic inactiveThumbIcon;

  void setInactiveThumbIcon(dynamic value) {
    onNotifyWithCallback(() => inactiveThumbIcon = value);
  }

  Color? activeThumbIconTint;

  void setActiveThumbIconTint(Color? value) {
    onNotifyWithCallback(() => activeThumbIconTint = value);
  }

  Color? inactiveThumbIconTint;

  void setInactiveThumbIconTint(Color? value) {
    onNotifyWithCallback(() => inactiveThumbIconTint = value);
  }

  double? activeThumbSpacing;

  void setActiveThumbSpacing(double? value) {
    onNotifyWithCallback(() => activeThumbSpacing = value);
  }

  double? inactiveThumbSpacing;

  void setInactiveThumbSpacing(double? value) {
    onNotifyWithCallback(() => inactiveThumbSpacing = value);
  }

  double? activeThumbStrokeSize;

  void setActiveThumbStrokeSize(double? value) {
    onNotifyWithCallback(() => activeThumbStrokeSize = value);
  }

  double? inactiveThumbStrokeSize;

  void setInactiveThumbStrokeSize(double? value) {
    onNotifyWithCallback(() => inactiveThumbStrokeSize = value);
  }

  double? thumbIconSpacing;

  void setThumbIconSpacing(double? value) {
    onNotifyWithCallback(() => thumbIconSpacing = value);
  }

  int thumbWalkingTime = 200;

  void setThumbWalkingTime(int value) {
    onNotifyWithCallback(() => thumbWalkingTime = value);
  }

  double? trackBorderRadius;

  void setTrackBorderRadius(double? value) {
    onNotifyWithCallback(() => trackBorderRadius = value);
  }

  double? trackStrokeSize;

  void setTrackStrokeSize(double? value) {
    onNotifyWithCallback(() => trackStrokeSize = value);
  }

  double trackRatio = 1.65;

  void setTrackRatio(double value) {
    onNotifyWithCallback(() => trackRatio = value);
  }

  void setValue(bool value) {
    super.setActivated(value);
  }

  SwitchViewController fromSwitchView(SwitchView view) {
    super.fromView(view);
    size = view.size;
    activeThumbColor = view.activeThumbColor;
    inactiveThumbColor = view.inactiveThumbColor;
    activeThumbStrokeColor = view.activeThumbStrokeColor;
    inactiveThumbStrokeColor = view.inactiveThumbStrokeColor;
    activeTrackColor = view.activeTrackColor;
    inactiveTrackColor = view.inactiveTrackColor;
    activeTrackStrokeColor = view.activeTrackStrokeColor;
    inactiveTrackStrokeColor = view.inactiveTrackStrokeColor;
    activeThumbIcon = view.activeThumbIcon;
    inactiveThumbIcon = view.inactiveThumbIcon;
    activeThumbIconTint = view.activeThumbIconTint;
    inactiveThumbIconTint = view.inactiveThumbIconTint;
    activeThumbSpacing = view.activeThumbSpacing;
    inactiveThumbSpacing = view.inactiveThumbSpacing;
    activeThumbStrokeSize = view.activeThumbStrokeSize;
    inactiveThumbStrokeSize = view.inactiveThumbStrokeSize;
    thumbIconSpacing = view.thumbIconSpacing;
    thumbWalkingTime = view.thumbWalkingTime;
    trackBorderRadius = view.trackBorderRadius;
    trackStrokeSize = view.trackStrokeSize;
    trackRatio = view.trackRatio;
    return this;
  }
}

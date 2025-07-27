part of 'view.dart';

class SettingsViewController extends ViewController {
  dynamic icon;

  void setIcon(dynamic value) {
    onNotifyWithCallback(() => icon = value);
  }

  double? iconSize;

  void setIconSize(double? value) {
    onNotifyWithCallback(() => iconSize = value);
  }

  Color? iconTint;

  void setIconTint(Color? value) {
    onNotifyWithCallback(() => iconTint = value);
  }

  String? title;

  void setTitle(String? value) {
    onNotifyWithCallback(() => title = value);
  }

  TextStyle? titleStyle;

  void setTitleStyle(TextStyle? value) {
    onNotifyWithCallback(() => titleStyle = value);
  }

  String? _summary;

  set summary(String? value) => _summary = value;

  void setSummary(String? value) {
    onNotifyWithCallback(() => summary = value);
  }

  ValueState<String>? summaryState;

  void setSummaryState(ValueState<String>? value) {
    onNotifyWithCallback(() => summaryState = value);
  }

  TextStyle? summaryStyle;

  void setSummaryStyle(TextStyle? value) {
    onNotifyWithCallback(() => summaryStyle = value);
  }

  SettingsViewType type = SettingsViewType.none;

  void setType(SettingsViewType value) {
    onNotifyWithCallback(() => type = value);
  }

  ArrowConfig arrowConfig = const ArrowConfig();

  void setArrowConfig(ArrowConfig value) {
    onNotifyWithCallback(() => arrowConfig = value);
  }

  CheckmarkConfig checkmarkConfig = const CheckmarkConfig();

  void setCheckmarkConfig(CheckmarkConfig value) {
    onNotifyWithCallback(() => checkmarkConfig = value);
  }

  SwitchConfig switchConfig = const SwitchConfig();

  void setSwitchConfig(SwitchConfig value) {
    onNotifyWithCallback(() => switchConfig = value);
  }

  SettingsViewController fromSettingsView(SettingsView view) {
    super.fromView(view);
    title = view.title;
    summary = view.summary;
    summaryState = view.summaryState;
    icon = view.icon;
    iconSize = view.iconSize;
    iconTint = view.iconTint;
    type = view.type;
    arrowConfig = view.arrowConfig;
    checkmarkConfig = view.checkmarkConfig;
    switchConfig = view.switchConfig;
    return this;
  }

  String? get summary => summaryState?.fromController(this) ?? _summary;
}

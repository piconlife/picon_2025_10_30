part of 'view.dart';

enum SettingsViewType {
  arrow,
  checkmark,
  switcher,
  none;

  bool get isArrow => this == SettingsViewType.arrow;

  bool get isCheckmark => this == SettingsViewType.checkmark;

  bool get isSwitcher => this == SettingsViewType.switcher;

  bool get isNone => this == SettingsViewType.none;
}

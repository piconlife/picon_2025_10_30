import 'package:app_color/app_color.dart';
import 'package:flutter/cupertino.dart';

class RootLogos {
  const RootLogos._();

  static String primary(bool dark) {
    return dark
        ? 'assets/app/branded_logo_dark.svg'
        : 'assets/app/branded_logo_light.svg';
  }

  static String secondary(bool dark) {
    return dark ? 'assets/app/logo_dark.svg' : 'assets/app/logo_light.svg';
  }

  static String tertiary(bool dark) {
    return dark
        ? 'assets/app/tertiary_dark.svg'
        : 'assets/app/tertiary_light.svg';
  }
}

extension InAppLogosHelper on BuildContext {
  String get logoPrimary => RootLogos.primary(isDarkMode);

  String get logoSecondary => RootLogos.secondary(isDarkMode);

  String get logoTertiary => RootLogos.tertiary(isDarkMode);
}

import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import '../constants/app.dart';

class InAppLogos {
  const InAppLogos._();

  static String primary(bool dark) {
    return dark ? AppConstants.logoDark : AppConstants.logo;
  }

  static String secondary(bool dark) {
    return dark ? AppConstants.logoSecondaryDark : AppConstants.logoSecondary;
  }

  static String tertiary(bool dark) {
    return dark ? AppConstants.logoTertiaryDark : AppConstants.logoTertiary;
  }
}

extension InAppLogosHelper on BuildContext {
  String get logoPrimary => InAppLogos.primary(isDarkMode);

  String get logoSecondary => InAppLogos.secondary(isDarkMode);

  String get logoTertiary => InAppLogos.tertiary(isDarkMode);
}

import 'package:app_color/app_color.dart';
import 'package:flutter/cupertino.dart';

class InAppLogos {
  const InAppLogos._();

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

  static String ai(bool dark) {
    return dark ? 'assets/app/ai_dark.svg' : 'assets/app/ai_light.svg';
  }
}

extension InAppLogosHelper on BuildContext {
  String get logoAi => InAppLogos.ai(isDarkMode);

  String get logoPrimary => InAppLogos.primary(isDarkMode);

  String get logoSecondary => InAppLogos.secondary(isDarkMode);

  String get logoTertiary => InAppLogos.tertiary(isDarkMode);
}

import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import '../../app/constants/app.dart';

extension LogoExtension on BuildContext {
  String get logo {
    return isDarkMode ? AppConstants.logoDark : AppConstants.logo;
  }

  String get logoFooter {
    return isDarkMode ? AppConstants.logoFooterDark : AppConstants.logoFooter;
  }

  String get logoHeader {
    return isDarkMode ? AppConstants.logoHeaderDark : AppConstants.logoHeader;
  }
}

import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';

class KColors {
  const KColors._();

  static const light = Color(0xFFD7DCDF);
  static const dark = Color(0xFF181C1F);
  static const grey = Color(0xff9e9ea7);
  static const green = Color(0xFF2ECA7F);
  static const blue = Color(0xFF19A4FA);
  static const red = Color(0xFFF44336);
  static const yellow = Color(0xFFFFC107);
}

class AppColors {
  const AppColors._();

  static const lightColor = Color(0xFFFAFAFA);

  static const holoLightColor = Color(0xFFF2F2F2);
  static const holoRedColor = Color(0xFFFA9F98);

  /// BASE COLORS
  static final primary = ThemeColor(
    light: const Color(0xff2eca7f),
    dark: const Color(0xff2eca7f),
  );

  static final secondary = ThemeColor(light: const Color(0xff19A4FA));

  static final ternary = ThemeColor(light: const Color(0xffFFC107));

  static final background = ThemeColor(
    light: const Color(0xfff2f2f2),
    dark: Colors.black,
  );

  static final drawerBackground = ThemeColor(
    light: Colors.white,
    dark: const Color(0xff121b22),
  );

  static final error = ThemeColor(light: Colors.red, dark: Colors.red);

  static final disable = ThemeColor(light: Colors.grey, dark: Colors.grey);

  static final appbar = ThemeColor(light: Colors.white, dark: Colors.black);

  static final appbarBottom = ThemeColor(
    light: Colors.white,
    dark: Colors.black,
  );

  static final appbarIcon = ThemeColor(light: Colors.black, dark: Colors.white);

  static final appbarTitle = ThemeColor(
    light: Colors.black,
    dark: Colors.white,
  );

  static final bottomNavigationBar = appbar;

  static final bottomNavigationBarSelectedItem = ThemeColor(
    light: primary,
    dark: primary,
  );

  static final bottomNavigationBarUnselectedItem = ThemeColor(
    light: Colors.grey,
    dark: Colors.grey,
  );

  static final bottomSheet = ThemeColor(
    light: Colors.white,
    dark: const Color(0xff121b22),
  );

  static final divider = ThemeColor(
    light: const Color(0xff84959f),
    dark: const Color(0xff84959f),
  );

  static final feedSeparator = ThemeColor(
    light: const Color(0xfff2f2f2),
    dark: Colors.black,
  );

  static final snackBar = ThemeColor(
    light: const Color(0xff121b22),
    dark: Colors.white,
  );

  static final snackBarBg = ThemeColor(
    light: const Color(0xff6b757b),
    dark: const Color(0xff121b22),
  );

  static final snackBarWarning = ThemeColor(
    light: Colors.orange,
    dark: Colors.white,
  );

  static final snackBarWarningBg = ThemeColor(
    light: Colors.orange.shade50,
    dark: Colors.orange.shade900,
  );

  static final snackBarError = ThemeColor(
    light: Colors.red,
    dark: Colors.white,
  );

  static final snackBarErrorBg = ThemeColor(
    light: Colors.red.shade50,
    dark: Colors.red.shade900,
  );

  static final statusBar = ThemeColor(light: appbar.light, dark: appbar.dark);

  static final statusBarIcon = ThemeColor(
    light: const Color(0xffd8ede8),
    dark: const Color(0xffdce0e3),
  );

  /// BODY COLORS
  static final bodyIcon = ThemeColor(light: Colors.grey);

  static final bodyTitleMedium = ThemeColor(
    light: const Color(0xff121b22),
    dark: const Color(0xffe8edf1),
  );

  static final bodySubtitle = ThemeColor(
    light: const Color(0xff667781),
    dark: const Color(0xff667781),
  );

  static final textColor = ThemeColor(light: Colors.black, dark: Colors.white);

  static final textHintColor = ThemeColor(
    light: Colors.black,
    dark: Colors.grey,
  );

  static final dialogBackgroundColor = ThemeColor(
    light: Colors.white,
    dark: const Color(0xff121b22),
  );

  static final dialogSurfaceTint = ThemeColor(light: Colors.transparent);

  static final dialogTitleTextColor = ThemeColor(
    light: Colors.black,
    dark: Colors.white,
  );

  static final dialogSubtitleTextColor = ThemeColor(
    light: Colors.black.t50,
    dark: Colors.white.t50,
  );

  static final pressedColor = ThemeColor(
    light: Colors.black.t05,
    dark: Colors.white.t05,
  );

  static final shadowColor = ThemeColor(
    light: Colors.black.t05,
    dark: Colors.white.t05,
  );

  static final splashColor = ThemeColor(
    light: Colors.black.t05,
    dark: Colors.white.t05,
  );

  static final colorScheme = ColorScheme.light(
    primary: primary.light,
    secondary: secondary.light,
    tertiary: ternary.light,
    error: error.light,
  );

  static final colorSchemeDark = ColorScheme.dark(
    primary: primary.dark,
    secondary: secondary.dark,
    tertiary: ternary.dark,
    error: error.dark,
  );

  static final light = KColors.light;
  static final grey = KColors.grey;
  static final green = KColors.green;
  static final blue = KColors.blue;
  static final red = KColors.red;
  static final yellow = KColors.yellow;
}

class AppForegroundColors {
  AppForegroundColors._();

  static Color description = Colors.black.withValues(alpha: 0.75);
  static Color iconTint = AppColors.grey.shade200;
}

class AppBackgroundColors {
  AppBackgroundColors._();

  static Color feedStory = Colors.white;
  static Color description = AppColors.light.light;
  static Color divider = AppColors.light.holoLight;
  static Color scaffold = AppColors.light.holoLight;
  static Color toolbar = Colors.white;
  static Brightness statusBarBrightness = Brightness.dark;
  static Color statusBar = Colors.transparent;
}

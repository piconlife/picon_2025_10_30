import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

ThemeData kLightTheme = ThemeData.light().copyWith(
  highlightColor: kHighlightColorsConfig.light.primary,
  hintColor: kHighlightColorsConfig.light.primary,
  primaryColor: kColorsConfig.light.primary,
  scaffoldBackgroundColor: kScaffoldColorsConfig.light.primary,
  splashColor: kSplashColorsConfig.light.primary,
  shadowColor: kShadowColorsConfig.light.primary,
  appBarTheme: AppBarTheme(),
  bottomAppBarTheme: BottomAppBarTheme(),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(),
  bottomSheetTheme: BottomSheetThemeData(),
  dividerTheme: DividerThemeData(),
  dialogTheme: DialogThemeData(),
  drawerTheme: DrawerThemeData(),
  iconTheme: IconThemeData(),
  snackBarTheme: SnackBarThemeData(),
  textTheme: TextTheme(),
);

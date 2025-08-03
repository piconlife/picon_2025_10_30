import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

ThemeData kDarkTheme = ThemeData.dark().copyWith(
  highlightColor: kHighlightColorsConfig.dark.primary,
  hintColor: kHighlightColorsConfig.dark.primary,
  primaryColor: kColorsConfig.dark.primary,
  scaffoldBackgroundColor: kScaffoldColorsConfig.dark.primary,
  splashColor: kSplashColorsConfig.dark.primary,
  shadowColor: kShadowColorsConfig.dark.primary,
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

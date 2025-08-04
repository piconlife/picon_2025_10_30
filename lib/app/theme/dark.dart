import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';

ThemeData get kDarkTheme {
  final colors = kColorsConfig.dark;
  final primary = colors.primary ?? kGreen.dark;
  final light = colors.lightAsFixed ?? Colors.white;
  final dark = colors.darkAsFixed ?? Colors.black;
  final secondary = colors.secondary ?? kBlue.dark;
  final tertiary = colors.tertiary ?? kOrange.dark;
  final error = colors.error ?? kRed.dark;
  final disable = colors.disable ?? kGrey.dark;
  final highlightColor = kHighlightColorsConfig.dark.primary ?? primary.t10;
  final hintColor = kHintColorsConfig.dark.primary ?? dark.t50;
  final scaffoldBackgroundColor = kScaffoldColorsConfig.dark.primary ?? light;
  final splashColor = kSplashColorsConfig.dark.primary ?? primary.t10;
  final shadowColor = kShadowColorsConfig.dark.primary ?? dark.t10;
  final surface = kSurfaceColorsConfig.dark.primary ?? Colors.transparent;
  return ThemeData.dark().copyWith(
    highlightColor: highlightColor,
    hintColor: hintColor,
    primaryColor: primary,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    splashColor: splashColor,
    shadowColor: shadowColor,
    colorScheme: ColorScheme.light(
      primary: primary,
      onPrimary: light,
      secondary: secondary,
      onSecondary: light,
      tertiary: tertiary,
      onTertiary: light,
      error: error,
      surface: surface,
    ),
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
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(light),
      overlayColor: WidgetStateProperty.all(primary.t10),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled) &&
            states.contains(WidgetState.selected)) {
          return primary.tint(0.3);
        }
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return null;
      }),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: primary.tint(0.3),
          );
        }
        return BorderSide(
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
          color: primary,
        );
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
  );
}

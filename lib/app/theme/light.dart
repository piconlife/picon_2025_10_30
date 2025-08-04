import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';

ThemeData get kLightTheme {
  final colors = kColorsConfig.light;
  final primary = colors.primary ?? kGreen.light;
  final light = colors.lightAsFixed ?? Colors.white;
  final dark = colors.darkAsFixed ?? Colors.black;
  final secondary = colors.secondary ?? kBlue.light;
  final tertiary = colors.tertiary ?? kOrange.light;
  final error = colors.error ?? kRed.light;
  final disable = colors.disable ?? kGrey.light;
  final highlightColor = kHighlightColorsConfig.light.primary ?? primary.t10;
  final hintColor = kHintColorsConfig.light.primary ?? dark.t50;
  final scaffoldBackgroundColor = kScaffoldColorsConfig.light.primary ?? light;
  final splashColor = kSplashColorsConfig.light.primary ?? primary.t10;
  final shadowColor = kShadowColorsConfig.light.primary ?? dark.t10;
  final surface = kSurfaceColorsConfig.light.primary ?? Colors.transparent;
  return ThemeData.light().copyWith(
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

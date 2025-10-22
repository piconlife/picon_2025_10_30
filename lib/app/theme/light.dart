import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/fonts.dart';

ThemeData get kLightTheme {
  final colors = kColorsConfig.light;
  final primary = colors.primary ?? kGreen.light;
  final light = colors.lightAsFixed ?? Colors.white;
  final dark = colors.darkAsFixed ?? Colors.black;
  final grey = colors.mid ?? kGrey.light;
  final secondary = colors.secondary ?? kBlue.light;
  final tertiary = colors.tertiary ?? kOrange.light;
  final error = colors.error ?? kRed.light;
  final highlightColor = kHighlightColorsConfig.light.primary ?? dark.t10;
  final hintColor = kHintColorsConfig.light.primary ?? dark.t50;
  final dividerColor = kDividerColorsConfig.light.primary ?? dark.t05;
  final scaffoldBackgroundColor = kScaffoldColorsConfig.light.primary ?? light;
  final splashColor = kSplashColorsConfig.light.primary ?? dark.t05;
  final shadowColor = kShadowColorsConfig.light.primary ?? dark.t05;
  final dialogBackgroundColor = kDialogColorsConfig.light.primary ?? light;

  final bnbUnselectedIconTheme = IconThemeData(size: 24, color: grey);

  final bnbUnselectedLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: grey,
  );

  return ThemeData.from(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      error: error,
    ),
  ).copyWith(
    highlightColor: highlightColor,
    hintColor: hintColor,
    primaryColor: primary,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    splashColor: splashColor,
    shadowColor: shadowColor,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: grey, size: 24),
      titleTextStyle: TextStyle(
        color: dark,
        fontSize: 18,
        fontFamily: InAppFonts.primary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: light.withValues(alpha: 0.002),
        systemNavigationBarColor: light.withValues(alpha: 0.002),
        systemNavigationBarContrastEnforced: true,
        systemStatusBarContrastEnforced: true,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(
      elevation: 0.5,
      color: light,
      surfaceTintColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primary,
      unselectedItemColor: grey,
      selectedIconTheme: bnbUnselectedIconTheme.copyWith(color: primary),
      unselectedIconTheme: bnbUnselectedIconTheme,
      selectedLabelStyle: bnbUnselectedLabelStyle.copyWith(color: primary),
      unselectedLabelStyle: bnbUnselectedLabelStyle,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: dialogBackgroundColor,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: dialogBackgroundColor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(color: dark),
      contentTextStyle: TextStyle(color: dark.t50),
    ),
    dividerTheme: DividerThemeData(color: dividerColor.t10),
    drawerTheme: DrawerThemeData(backgroundColor: dialogBackgroundColor),
    iconTheme: IconThemeData(color: dark),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: dialogBackgroundColor,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: dark),
      bodyMedium: TextStyle(color: dark),
      titleLarge: TextStyle(color: dark),
      titleMedium: TextStyle(color: dark, fontSize: 16),
      titleSmall: TextStyle(color: grey, fontSize: 14),
    ),
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

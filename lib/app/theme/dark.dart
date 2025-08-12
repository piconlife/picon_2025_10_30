import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/fonts.dart';

ThemeData get kDarkTheme {
  final colors = kColorsConfig.dark;
  final primary = colors.primary ?? kGreen.dark;
  final light = colors.lightAsFixed ?? Colors.white;
  final dark = colors.darkAsFixed ?? Colors.black;
  final grey = colors.mid ?? kGrey.dark;
  final secondary = colors.secondary ?? kBlue.dark;
  final tertiary = colors.tertiary ?? kOrange.dark;
  final error = colors.error ?? kRed.dark;

  final highlightColor = kHighlightColorsConfig.dark.primary ?? light.t10;
  final hintColor = kHintColorsConfig.dark.primary ?? light.t50;
  final dividerColor = kDividerColorsConfig.dark.primary ?? light.t05;
  final scaffoldBackgroundColor = kScaffoldColorsConfig.dark.primary ?? dark;
  final splashColor = kSplashColorsConfig.dark.primary ?? light.t05;
  final shadowColor = kShadowColorsConfig.dark.primary ?? light.t05;
  final dialogBackgroundColor = kDialogColorsConfig.dark.primary ?? dark;

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
        color: light,
        fontSize: 18,
        fontFamily: InAppFonts.primary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: dark.withValues(alpha: 0.002),
        systemNavigationBarColor: dark.withValues(alpha: 0.002),
        systemNavigationBarContrastEnforced: true,
        systemStatusBarContrastEnforced: true,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
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
      titleTextStyle: TextStyle(color: light),
      contentTextStyle: TextStyle(color: light.t50),
    ),
    dividerTheme: DividerThemeData(color: dividerColor.t10),
    drawerTheme: DrawerThemeData(backgroundColor: dialogBackgroundColor),
    iconTheme: IconThemeData(color: light),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: dialogBackgroundColor,
      elevation: 0,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: light),
      bodyMedium: TextStyle(color: light),
      titleLarge: TextStyle(color: light),
      titleMedium: TextStyle(color: light, fontSize: 16),
      titleSmall: TextStyle(color: grey, fontSize: 14),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(dark),
      overlayColor: WidgetStateProperty.all(primary.t10),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled) &&
            states.contains(WidgetState.selected)) {
          return primary.shade(0.3);
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
            color: primary.shade(0.3),
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

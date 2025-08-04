import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData get kDarkTheme {
  final colors = kColorsConfig.dark;
  final primary = colors.primary ?? kGreen.dark;
  final light = colors.lightAsFixed ?? Colors.white;
  final dark = colors.darkAsFixed ?? Colors.black;
  final secondary = colors.secondary ?? kBlue.dark;
  final tertiary = colors.tertiary ?? kOrange.dark;
  final error = colors.error ?? kRed.dark;
  final grey = colors.mid ?? kGrey.dark;
  final highlightColor = kHighlightColorsConfig.dark.primary ?? primary.t10;
  final hintColor = kHintColorsConfig.dark.primary ?? dark.t50;
  final scaffoldBackgroundColor = kScaffoldColorsConfig.dark.primary ?? light;
  final splashColor = kSplashColorsConfig.dark.primary ?? primary.t10;
  final shadowColor = kShadowColorsConfig.dark.primary ?? dark.t10;
  final surface = kSurfaceColorsConfig.dark.primary ?? Colors.transparent;
  final dialogBackgroundColor = kDialogColorsConfig.dark.primary ?? dark;
  final bottomAppbarBackgroundColor = kBottomColorsConfig.dark.primary ?? dark;
  final dividerColor = kDividerColorsConfig.dark.primary ?? dark.t10;
  final iconColor = kIconColorsConfig.dark.primary ?? light;

  final bnbUnselectedIconTheme = IconThemeData(size: 24, color: grey);

  final bnbUnselectedLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: grey,
  );

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
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: dark,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: light),
      titleTextStyle: TextStyle(color: light, fontSize: 18),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
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
      color: bottomAppbarBackgroundColor,
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
    dividerTheme: DividerThemeData(color: dividerColor),
    dialogTheme: DialogThemeData(
      backgroundColor: dialogBackgroundColor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(color: light),
      contentTextStyle: TextStyle(color: light.t50),
    ),
    drawerTheme: DrawerThemeData(backgroundColor: dialogBackgroundColor),
    iconTheme: IconThemeData(color: iconColor),
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

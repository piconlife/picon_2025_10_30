import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get I => Theme.of(this);

  Color get primaryColor => I.primaryColor;

  Color get primaryColorDark => I.primaryColorDark;

  Color get primaryColorLight => I.primaryColorLight;

  Color get backgroundColor => I.scaffoldBackgroundColor;

  Color? get bottomAppBarColor => I.bottomAppBarTheme.color;

  Color get canvasColor => I.canvasColor;

  Color get cardColor => I.cardColor;

  Color get dialogBackgroundColor =>
      I.dialogTheme.backgroundColor ?? Colors.transparent;

  Color get focusColor => I.focusColor;

  Color get highlightColor => I.highlightColor;

  Color get hintColor => I.hintColor;

  Color get hoverColor => I.hoverColor;

  Color get disabledColor => I.disabledColor;

  Color get dividerColor => I.dividerColor;

  Color get errorColor => Colors.red;

  Color get indicatorColor => I.indicatorColor;

  Color get scaffoldBackgroundColor => I.scaffoldBackgroundColor;

  Color get secondaryHeaderColor => I.secondaryHeaderColor;

  Color get shadowColor => I.shadowColor;

  Color get splashColor => I.splashColor;

  Color get unselectedWidgetColor => I.unselectedWidgetColor;

  TextStyle get bodySmall => textTheme.bodySmall.i;

  TextStyle get bodyMedium => textTheme.bodyMedium.i;

  TextStyle get bodyLarge => textTheme.bodyLarge.i;

  TextStyle get displaySmall => textTheme.displaySmall.i;

  TextStyle get displayMedium => textTheme.displayMedium.i;

  TextStyle get displayLarge => textTheme.displayLarge.i;

  TextStyle get headlineSmall => textTheme.headlineSmall.i;

  TextStyle get headlineMedium => textTheme.headlineMedium.i;

  TextStyle get headlineLarge => textTheme.headlineLarge.i;

  TextStyle get labelSmall => textTheme.labelSmall.i;

  TextStyle get labelMedium => textTheme.labelMedium.i;

  TextStyle get labelLarge => textTheme.labelLarge.i;

  TextStyle get titleSmall => textTheme.titleSmall.i;

  TextStyle get titleMedium => textTheme.titleMedium.i;

  TextStyle get titleLarge => textTheme.titleLarge.i;

  ActionIconThemeData? get actionIconTheme => I.actionIconTheme;

  AppBarTheme get appBarTheme => I.appBarTheme;

  BadgeThemeData get badgeTheme => I.badgeTheme;

  MaterialBannerThemeData get bannerTheme => I.bannerTheme;

  BottomAppBarTheme get bottomAppBarTheme => I.bottomAppBarTheme;

  BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      I.bottomNavigationBarTheme;

  BottomSheetThemeData get bottomSheetTheme => I.bottomSheetTheme;

  Brightness get brightness => I.brightness;

  ButtonBarThemeData get buttonBarTheme => I.buttonBarTheme;

  ButtonThemeData get buttonTheme => I.buttonTheme;

  CardThemeData get cardTheme => I.cardTheme;

  CheckboxThemeData get checkboxTheme => I.checkboxTheme;

  ChipThemeData get chipTheme => I.chipTheme;

  ColorScheme get colorScheme => I.colorScheme;

  NoDefaultCupertinoThemeData? get cupertinoOverrideTheme =>
      I.cupertinoOverrideTheme;

  DataTableThemeData get dataTableTheme => I.dataTableTheme;

  DatePickerThemeData get datePickerTheme => I.datePickerTheme;

  DialogThemeData get dialogTheme => I.dialogTheme;

  DividerThemeData get dividerTheme => I.dividerTheme;

  DrawerThemeData get drawerTheme => I.drawerTheme;

  DropdownMenuThemeData get dropdownMenuTheme => I.dropdownMenuTheme;

  ElevatedButtonThemeData get elevatedButtonTheme => I.elevatedButtonTheme;

  ExpansionTileThemeData get expansionTileTheme => I.expansionTileTheme;

  FilledButtonThemeData get filledButtonTheme => I.filledButtonTheme;

  FloatingActionButtonThemeData get floatingActionButtonTheme =>
      I.floatingActionButtonTheme;

  IconButtonThemeData get iconButtonTheme => I.iconButtonTheme;

  IconThemeData get iconTheme => I.iconTheme;

  InputDecorationTheme get inputDecorationTheme => I.inputDecorationTheme;

  ListTileThemeData get listTileTheme => I.listTileTheme;

  MenuBarThemeData get menuBarTheme => I.menuBarTheme;

  MenuButtonThemeData get menuButtonTheme => I.menuButtonTheme;

  MenuThemeData get menuTheme => I.menuTheme;

  NavigationBarThemeData get navigationBarTheme => I.navigationBarTheme;

  NavigationDrawerThemeData get navigationDrawerTheme =>
      I.navigationDrawerTheme;

  NavigationRailThemeData get navigationRailTheme => I.navigationRailTheme;

  OutlinedButtonThemeData get outlinedButtonTheme => I.outlinedButtonTheme;

  PageTransitionsTheme get pageTransitionsTheme => I.pageTransitionsTheme;

  PopupMenuThemeData get popupMenuTheme => I.popupMenuTheme;

  IconThemeData get primaryIconTheme => I.primaryIconTheme;

  TextTheme get primaryTextTheme => I.primaryTextTheme;

  ProgressIndicatorThemeData get progressIndicatorTheme =>
      I.progressIndicatorTheme;

  RadioThemeData get radioTheme => I.radioTheme;

  ScrollbarThemeData get scrollbarTheme => I.scrollbarTheme;

  SearchBarThemeData get searchBarTheme => I.searchBarTheme;

  SearchViewThemeData get searchViewTheme => I.searchViewTheme;

  SegmentedButtonThemeData get segmentedButtonTheme => I.segmentedButtonTheme;

  SliderThemeData get sliderTheme => I.sliderTheme;

  SnackBarThemeData get snackBarTheme => I.snackBarTheme;

  SwitchThemeData get switchTheme => I.switchTheme;

  TabBarThemeData get tabBarTheme => I.tabBarTheme;

  TextButtonThemeData get textButtonTheme => I.textButtonTheme;

  TextSelectionThemeData get textSelectionTheme => I.textSelectionTheme;

  TextTheme get textTheme => I.textTheme;

  TimePickerThemeData get timePickerTheme => I.timePickerTheme;

  ToggleButtonsThemeData get toggleButtonsTheme => I.toggleButtonsTheme;

  TooltipThemeData get tooltipTheme => I.tooltipTheme;
}

extension _TSExtension on TextStyle? {
  TextStyle get i => this ?? const TextStyle();
}

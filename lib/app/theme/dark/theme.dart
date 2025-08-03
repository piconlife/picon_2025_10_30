import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../styles/colors.dart';

part 'app_bar.dart';
part 'bottom_app_bar.dart';
part 'bottom_navigation_bar.dart';
part 'bottom_sheet.dart';
part 'dialog.dart';
part 'divider.dart';
part 'drawer.dart';
part 'icon.dart';
part 'snack_bar.dart';
part 'text.dart';

ThemeData kDarkTheme =
    ThemeData.from(
      useMaterial3: true,
      colorScheme: AppColors.colorSchemeDark,
    ).copyWith(
      highlightColor: AppColors.pressedColor.dark,
      hintColor: AppColors.textHintColor.dark,
      primaryColor: AppColors.primary.dark,
      scaffoldBackgroundColor: AppColors.background.dark,
      splashColor: AppColors.splashColor.dark,
      shadowColor: AppColors.shadowColor.dark,
      appBarTheme: _kAppbarTheme,
      bottomAppBarTheme: _kBottomAppBarTheme,
      bottomNavigationBarTheme: _kBottomNavigationBarTheme,
      bottomSheetTheme: _kBottomSheetTheme,
      dividerTheme: _kDividerTheme,
      dialogTheme: _kDialogTheme,
      drawerTheme: _kDrawerTheme,
      iconTheme: _kIconTheme,
      snackBarTheme: _kSnackBarTheme,
      textTheme: _kTextTheme,
    );

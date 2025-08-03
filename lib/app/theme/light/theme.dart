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

ThemeData kLightTheme =
    ThemeData.from(
      useMaterial3: true,
      colorScheme: AppColors.colorScheme,
    ).copyWith(
      highlightColor: AppColors.pressedColor.light,
      hintColor: AppColors.textHintColor.light,
      primaryColor: AppColors.primary.light,
      scaffoldBackgroundColor: AppColors.background.light,
      splashColor: AppColors.splashColor.light,
      shadowColor: AppColors.shadowColor.light,
      appBarTheme: _kAppbarTheme,
      bottomAppBarTheme: _kBottomAppBarTheme,
      bottomNavigationBarTheme: _kBottomNavigationBarTheme,
      bottomSheetTheme: _kBottomSheetTheme,
      dividerTheme: _kDividerTheme,
      dialogTheme: _kDialogTheme,
      dialogBackgroundColor: _kDialogTheme.backgroundColor,
      drawerTheme: _kDrawerTheme,
      iconTheme: _kIconTheme,
      snackBarTheme: _kSnackBarTheme,
      textTheme: _kTextTheme,
    );

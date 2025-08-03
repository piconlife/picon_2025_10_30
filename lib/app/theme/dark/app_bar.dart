part of 'theme.dart';

final _kAppbarTheme = AppBarTheme(
  elevation: 0,
  backgroundColor: AppColors.appbar.dark,
  surfaceTintColor: Colors.transparent,
  iconTheme: IconThemeData(color: AppColors.appbarIcon.dark),
  titleTextStyle: TextStyle(color: AppColors.appbarTitle.dark, fontSize: 18),
  systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ),
);

part of 'theme.dart';

final _kAppbarTheme = AppBarTheme(
  elevation: 0,
  backgroundColor: AppColors.appbar.light,
  surfaceTintColor: Colors.transparent,
  iconTheme: IconThemeData(color: AppColors.appbarIcon.light, size: 24),
  titleTextStyle: TextStyle(
    color: AppColors.appbarTitle.light,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ),
);

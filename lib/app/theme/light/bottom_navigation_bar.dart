part of 'theme.dart';

final _kBottomNavigationBarTheme = BottomNavigationBarThemeData(
  selectedItemColor: AppColors.bottomNavigationBarSelectedItem.light,
  unselectedItemColor: AppColors.bottomNavigationBarUnselectedItem.light,
  selectedIconTheme: __bnbSelectedIconTheme,
  unselectedIconTheme: __bnbUnselectedIconTheme,
  selectedLabelStyle: __bnbSelectedLabelStyle,
  unselectedLabelStyle: __bnbUnselectedLabelStyle,
);

final __bnbUnselectedIconTheme = IconThemeData(
  size: 24,
  color: AppColors.bottomNavigationBarUnselectedItem.light,
);

final __bnbSelectedIconTheme = __bnbUnselectedIconTheme.copyWith(
  color: AppColors.bottomNavigationBarSelectedItem.light,
);

final __bnbUnselectedLabelStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: AppColors.bottomNavigationBarUnselectedItem.light,
);

final __bnbSelectedLabelStyle = __bnbUnselectedLabelStyle.copyWith(
  color: AppColors.bottomNavigationBarSelectedItem.light,
);

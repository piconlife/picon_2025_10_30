part of 'theme.dart';

final _kBottomNavigationBarTheme = BottomNavigationBarThemeData(
  selectedItemColor: AppColors.bottomNavigationBarSelectedItem.dark,
  unselectedItemColor: AppColors.bottomNavigationBarUnselectedItem.dark,
  selectedIconTheme: __bnbSelectedIconTheme,
  unselectedIconTheme: __bnbUnselectedIconTheme,
  selectedLabelStyle: __bnbSelectedLabelStyle,
  unselectedLabelStyle: __bnbUnselectedLabelStyle,
);

final __bnbUnselectedIconTheme = IconThemeData(
  size: 24,
  color: AppColors.bottomNavigationBarUnselectedItem.dark,
);

final __bnbSelectedIconTheme = __bnbUnselectedIconTheme.copyWith(
  color: AppColors.bottomNavigationBarSelectedItem.dark,
);

final __bnbUnselectedLabelStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: AppColors.bottomNavigationBarUnselectedItem.dark,
);

final __bnbSelectedLabelStyle = __bnbUnselectedLabelStyle.copyWith(
  color: AppColors.bottomNavigationBarSelectedItem.dark,
);

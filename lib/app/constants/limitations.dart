class Limitations {
  const Limitations._();

  static const ageMaximum = 75;
  static const ageMinimum = 10;
  static const maxFullname = 30;
  static const maxUsername = 20;
  static const minUsername = 3;
  static const minFullname = 3;
  static const maxEmail = 20;
  static const minEmail = 5;
  static const maxPassword = 25;
  static const minPassword = 6;
  static const userRating = 3.0;
}

class AppLimitations {
  AppLimitations._();

  static const int maxFullNameLength = 30;
  static const int maxUsernameLength = 20;
  static const int minUsernameLength = 3;
  static const int maxPasswordLength = 30;
  static const int maxUserTitleLength = 50;
  static const int maxUserBiographyLength = 150;
  static const int verifyUserReportLimit = 50;
  static const int previousPostHeaderMaxLine = 2;
  static const int previousPostDescriptionMaxLine = 2;
  static const int usernameMaxLine = 5;
  static const int commentMaxLine = 5;
}

class AppMaxLines {
  AppMaxLines._();

  static const int description = 5;
}

class AppMaxCharacters {
  AppMaxCharacters._();

  static const int noteTitle = 50;
  static const int noteBody = 250;
  static const int description = 50;
}

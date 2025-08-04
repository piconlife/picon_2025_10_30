import 'package:flutter_androssy_kits/widgets.dart';

import '../../app/constants/limitations.dart';

class AuthErrors {
  const AuthErrors._();

  static const maximum = "Maximum";
  static const minimum = "Minimum";
  static const charactersRequire = "characters require";

  static String maximumCharacterExp(int length) {
    const start = maximum;
    final number = "$length";
    const end = charactersRequire;
    return "$start $number $end";
  }

  static String minimumCharacterExp(int length) {
    const start = minimum;
    final number = "$length";
    const end = charactersRequire;
    return "$start $number $end";
  }

  static String? prefix(AndrossyFieldError error) {
    if (error.isMinimum) {
      return AuthErrors.minimumCharacterExp(Limitations.minPrefix);
    } else if (error.isMaximum) {
      return AuthErrors.maximumCharacterExp(Limitations.maxPrefix);
    } else if (error.isAlreadyFound) {
      return "Prefix is unavailable!";
    } else if (error.isNetworkError) {
      return "Network is unavailable!";
    } else {
      return null;
    }
  }

  static String? password(AndrossyFieldError error) {
    if (error.isMinimum) {
      return AuthErrors.minimumCharacterExp(Limitations.minPassword);
    } else if (error.isMaximum) {
      return AuthErrors.maximumCharacterExp(Limitations.maxPassword);
    } else {
      return null;
    }
  }

  static String? phone(AndrossyFieldError error) {
    if (error.isAlreadyFound) {
      return "Phone number already existed!";
    } else if (error.isNetworkError) {
      return "Network is unavailable!";
    } else if (error.isInvalid) {
      return "Phone number is not valid!";
    } else {
      return null;
    }
  }

  static String? fullname(AndrossyFieldError error) {
    if (error.isMinimum) {
      return minimumCharacterExp(Limitations.minFullname);
    } else if (error.isMaximum) {
      return maximumCharacterExp(Limitations.maxFullname);
    } else {
      return null;
    }
  }

  static String? shortname(AndrossyFieldError error) {
    if (error.isAlreadyFound) {
      return "Username is unavailable!";
    } else if (error.isNetworkError) {
      return "Network is unavailable!";
    } else if (error.isMinimum) {
      return minimumCharacterExp(Limitations.minUsername);
    } else if (error.isMaximum) {
      return maximumCharacterExp(Limitations.maxUsername);
    } else {
      return null;
    }
  }
}

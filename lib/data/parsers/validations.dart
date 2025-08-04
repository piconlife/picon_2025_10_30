import 'package:flutter_andomie/utils/validator.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../app/constants/app.dart';
import '../../app/constants/limitations.dart';
import 'phone_parser.dart';

bool isValidFullname(String? value) {
  return value.isValidString(
    maxLength: Limitations.maxFullname,
    minLength: Limitations.minFullname,
  );
}

bool isValidUsername(String? value) {
  return value.isValidString(
    minLength: Limitations.minUsername,
    maxLength: Limitations.maxUsername,
  );
}

bool isValidPrefix(String? value) {
  if (value == null || value.isEmpty || value.contains('@')) {
    return false;
  }
  return value.isValidString(
    minLength: Limitations.minPrefix,
    maxLength: Limitations.maxPrefix,
  );
}

bool isValidEmail(String? value) {
  if (value == null || value.isEmpty || !value.contains(AppConstants.domain)) {
    return false;
  }
  return value.isValidEmail();
}

bool isValidPrefixOrEmail(String value) {
  return isValidPrefix(value) || isValidEmail(value);
}

bool isValidNumber(String? number) {
  if (number == null || number.isEmpty) {
    return false;
  }
  try {
    final phone = parsePhoneNumber(null, number);
    return isValidPhoneNumber(phone);
  } catch (_) {
    return false;
  }
}

bool isValidPhone(String? isoCode, String? number) {
  if (isoCode == null || isoCode.isEmpty || number == null || number.isEmpty) {
    return false;
  }
  try {
    final phone = parsePhoneNumber(isoCode, number);
    return isValidPhoneNumber(phone);
  } catch (_) {
    return false;
  }
}

bool isValidPhoneNumber(PhoneNumber? number) {
  if (number == null) return false;
  try {
    return number.isValid(type: PhoneNumberType.mobile);
  } catch (_) {
    return false;
  }
}

bool isValidCountryCode(String? value) {
  return value != null && value.isNotEmpty;
}

bool isValidPassword(String? value) {
  return value.isValidPassword(
    maxLength: Limitations.maxPassword,
    minLength: Limitations.minPassword,
  );
}

bool isValidOtp(String? value) {
  return value!.toUpperCase().isValidString(
    maxLength: Limitations.maxOtp,
    minLength: Limitations.minOtp,
  );
}

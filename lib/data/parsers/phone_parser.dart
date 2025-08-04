import 'package:phone_numbers_parser/phone_numbers_parser.dart';

PhoneNumber? parsePhoneNumber(String? isoCode, String nsn) {
  try {
    final iso = isoCode == null ? null : IsoCode.fromJson(isoCode);
    final number = PhoneNumber.parse(
      nsn,
      callerCountry: iso,
      destinationCountry: iso,
    );
    return number;
  } catch (_) {
    return null;
  }
}

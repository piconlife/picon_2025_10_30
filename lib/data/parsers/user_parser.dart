import 'package:flutter_andomie/utils/converter.dart';

import '../../app/constants/app.dart';
import '../../roots/helpers/encryptor.dart';

class UserParser {
  const UserParser._();

  static String? asEmail(String? prefix, [String? optional]) {
    if (prefix == null) return optional;
    return Converter.toMail(
      prefix,
      AppConstants.domainSuffix,
      AppConstants.domainEndpoint,
    );
  }

  static String? asPrefix(String? email, [String? optional]) {
    return email?.replaceAll(AppConstants.domain, '') ?? optional;
  }

  static String? encryptPassword(String? password) {
    final encryptor = EncryptorHelper.password();
    if (encryptor == null) return null;
    final x = encryptor.encode(password, usePasscode: true);
    final y = encryptor.encode(x, useVersion: true);
    return y;
  }

  static String? decryptPassword(String? encryptedPassword) {
    final version = EncryptorHelper.findVersion(encryptedPassword);
    final encryptor = EncryptorHelper.password(version);
    if (version == null || encryptor == null) return null;
    final x = encryptor.decode(encryptedPassword);
    final y = encryptor.decode(x);
    return y;
  }
}
